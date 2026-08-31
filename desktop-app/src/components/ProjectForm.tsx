import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useState, useEffect } from "react";
import { ImagePlus, X, Plus, Trash2 } from "lucide-react";
import { Project, TechCategory, Feature } from "../types/project";

// Tipo para la API nativa de Electron expuesta vía contextBridge
declare global {
  interface Window {
    electronAPI: {
      selectImage: () => Promise<{ dataUrl: string; fileName: string; mimeType: string } | null>;
    };
  }
}

// ── Utilidades ────────────────────────────────────────────────────────────────

// Convierte un dataUrl base64 devuelto por Electron en un File object para FormData
function dataUrlToFile(dataUrl: string, fileName: string, mimeType: string): File {
  const byteString = atob(dataUrl.split(",")[1]);
  const ab = new ArrayBuffer(byteString.length);
  const ia = new Uint8Array(ab);
  for (let i = 0; i < byteString.length; i++) ia[i] = byteString.charCodeAt(i);
  return new File([ab], fileName, { type: mimeType });
}

const generateSlug = (title: string) =>
  title
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9\s-]/g, "")
    .trim()
    .replace(/\s+/g, "-");

// ── Zod schema ────────────────────────────────────────────────────────────────

const projectSchema = z.object({
  // General
  title: z.string().min(1, "El título es requerido"),
  slug: z.string().min(1, "El slug es requerido"),
  order: z.number().int().min(0),
  project_type: z.enum(["web_app", "mobile_app", "api", "library", "tool"]),
  is_published: z.boolean(),
  is_featured: z.boolean(),

  // Hero
  tagline: z.string().optional(),
  cta_primary_label: z.string().optional(),
  cta_primary_url: z.string().optional(),
  cta_secondary_label: z.string().optional(),
  cta_secondary_url: z.string().optional(),
  repository_url: z.string().optional(),

  // Metadata
  role: z.string().optional(),
  year: z.number().int().nullable().optional(),
  status: z.enum(["Live", "In Development", "Deprecated", "Open Source"]).optional(),
  client: z.string().optional(),
  duration: z.string().optional(),
  team_size: z.string().optional(),

  // Contenido (arrays se sincronizan vía setValue desde local state)
  challenge_paragraph_1: z.string().optional(),
  challenge_paragraph_2: z.string().optional(),
  key_challenges: z.array(z.string()),
  features: z.array(z.object({ title: z.string(), description: z.string() })),

  // Tech Stack
  tech_stack: z.array(z.object({ category: z.string(), technologies: z.array(z.string()) })),

  // Galería & Card
  main_screenshot_url: z.string().optional(),
  screenshots: z.array(z.string()),
  card_short_description: z.string().optional(),
  tags: z.array(z.string()),
  metrics: z.array(z.string()),

  // SEO
  seo_title: z.string().optional(),
  seo_description: z.string().optional(),
});

type ProjectFormData = z.infer<typeof projectSchema>;

// ── Tipos locales para estado complejo ────────────────────────────────────────

type TechCategoryLocal = TechCategory & { techInput: string };

export interface ProjectFormFiles {
  heroFile?: File;
  cardFile?: File;
}

interface Props {
  onSubmit: (data: ProjectFormData, files: ProjectFormFiles) => void | Promise<void>;
  defaultValues?: Partial<Project>;
}

// ── Tabs ──────────────────────────────────────────────────────────────────────

const TABS = ["General", "Hero", "Metadata", "Contenido", "Tech Stack", "Galería & Card"] as const;
type Tab = (typeof TABS)[number];

// ── Estilos comunes ───────────────────────────────────────────────────────────

const input =
  "w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white placeholder:text-gray-600 focus:outline-none focus:border-blue-500 text-sm";
const label = "text-xs text-gray-400 font-mono";
const sectionTitle = "text-xs text-blue-400 font-mono mb-3 mt-5 uppercase tracking-wider";
const tagStyle =
  "flex items-center gap-1 bg-gray-700 text-gray-200 text-xs px-2 py-1 rounded-full";

// ── Componente ────────────────────────────────────────────────────────────────

const ProjectForm = ({ onSubmit, defaultValues }: Props) => {
  const [activeTab, setActiveTab] = useState<Tab>("General");

  // ── Imágenes (se seleccionan vía diálogo nativo de Electron) ─────────────
  const [heroFile, setHeroFile] = useState<File | null>(null);
  const [heroPreview, setHeroPreview] = useState(defaultValues?.hero_image_url ?? "");
  const [cardFile, setCardFile] = useState<File | null>(null);
  const [cardPreview, setCardPreview] = useState(defaultValues?.card_thumbnail_url ?? "");

  // Imagen principal de galería
  const [mainScreenshotFile, setMainScreenshotFile] = useState<File | null>(null);
  const [mainScreenshotPreview, setMainScreenshotPreview] = useState(defaultValues?.main_screenshot_url ?? "");

  // Screenshots secundarias — cada entrada puede ser un File nuevo o una URL ya existente
  const [screenshotFiles, setScreenshotFiles] = useState<Array<{ file: File; preview: string }>>([]);

  const selectImage = async (field: "hero" | "card" | "main") => {
    const result = await window.electronAPI.selectImage();
    if (!result) return;
    const file = dataUrlToFile(result.dataUrl, result.fileName, result.mimeType);
    if (field === "hero") {
      setHeroFile(file);
      setHeroPreview(result.dataUrl);
    } else if (field === "card") {
      setCardFile(file);
      setCardPreview(result.dataUrl);
    } else {
      setMainScreenshotFile(file);
      setMainScreenshotPreview(result.dataUrl);
    }
  };

  const addScreenshot = async () => {
    const result = await window.electronAPI.selectImage();
    if (!result) return;
    const file = dataUrlToFile(result.dataUrl, result.fileName, result.mimeType);
    setScreenshotFiles((prev) => [...prev, { file, preview: result.dataUrl }]);
  };

  const removeScreenshotFile = (index: number) => {
    setScreenshotFiles((prev) => prev.filter((_, i) => i !== index));
  };

  // Sube un File al endpoint /api/upload y devuelve la URL de Cloudinary
  const uploadToCloudinary = async (file: File): Promise<string> => {
    const formData = new FormData();
    formData.append("file", file);
    const res = await fetch(`${import.meta.env.VITE_API_URL}/api/upload`, {
      method: "POST",
      body: formData,
    });
    const json = await res.json();
    return json.url as string;
  };

  // ── Arrays de strings ─────────────────────────────────
  const [keyChallenges, setKeyChallenges] = useState<string[]>(defaultValues?.key_challenges ?? []);
  const [challengeInput, setChallengeInput] = useState("");
  const [tags, setTags] = useState<string[]>(defaultValues?.tags ?? []);
  const [tagInput, setTagInput] = useState("");
  const [metrics, setMetrics] = useState<string[]>(defaultValues?.metrics ?? []);
  const [metricInput, setMetricInput] = useState("");
  const [screenshots, setScreenshots] = useState<string[]>(defaultValues?.screenshots ?? []);

  // ── Features [{title, description}] ──────────────────
  const [features, setFeatures] = useState<Feature[]>(defaultValues?.features ?? []);

  // ── Tech Stack [{category, technologies}] ─────────────
  const [techCategories, setTechCategories] = useState<TechCategoryLocal[]>(
    (defaultValues?.tech_stack ?? []).map((tc) => ({ ...tc, techInput: "" })),
  );
  const [newCategoryInput, setNewCategoryInput] = useState("");

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<ProjectFormData>({
    resolver: zodResolver(projectSchema),
    defaultValues: {
      title: defaultValues?.title ?? "",
      slug: defaultValues?.slug ?? "",
      order: defaultValues?.order ?? 0,
      project_type: defaultValues?.project_type ?? "web_app",
      is_published: defaultValues?.is_published ?? false,
      is_featured: defaultValues?.is_featured ?? false,
      tagline: defaultValues?.tagline ?? "",
      cta_primary_label: defaultValues?.cta_primary_label ?? "",
      cta_primary_url: defaultValues?.cta_primary_url ?? "",
      cta_secondary_label: defaultValues?.cta_secondary_label ?? "",
      cta_secondary_url: defaultValues?.cta_secondary_url ?? "",
      repository_url: defaultValues?.repository_url ?? "",
      role: defaultValues?.role ?? "",
      year: defaultValues?.year ?? undefined,
      status: (defaultValues?.status as ProjectFormData["status"]) ?? undefined,
      client: defaultValues?.client ?? "",
      duration: defaultValues?.duration ?? "",
      team_size: defaultValues?.team_size ?? "",
      challenge_paragraph_1: defaultValues?.challenge_paragraph_1 ?? "",
      challenge_paragraph_2: defaultValues?.challenge_paragraph_2 ?? "",
      main_screenshot_url: defaultValues?.main_screenshot_url ?? "",
      card_short_description: defaultValues?.card_short_description ?? "",
      seo_title: defaultValues?.seo_title ?? "",
      seo_description: defaultValues?.seo_description ?? "",
      key_challenges: defaultValues?.key_challenges ?? [],
      features: defaultValues?.features ?? [],
      tech_stack: defaultValues?.tech_stack ?? [],
      screenshots: defaultValues?.screenshots ?? [],
      tags: defaultValues?.tags ?? [],
      metrics: defaultValues?.metrics ?? [],
    },
  });

  const titleValue = watch("title");
  const [slugLocked, setSlugLocked] = useState(!!defaultValues?.slug);

  // Auto-slug desde el título
  useEffect(() => {
    if (!slugLocked && titleValue) {
      setValue("slug", generateSlug(titleValue));
    }
  }, [titleValue, slugLocked]);

  // Sincronizar arrays locales con el form
  useEffect(() => { setValue("key_challenges", keyChallenges); }, [keyChallenges]);
  useEffect(() => { setValue("features", features); }, [features]);
  useEffect(() => { setValue("tech_stack", techCategories.map(({ techInput: _, ...rest }) => rest)); }, [techCategories]);
  useEffect(() => { setValue("tags", tags); }, [tags]);
  useEffect(() => { setValue("metrics", metrics); }, [metrics]);
  useEffect(() => { setValue("screenshots", screenshots); }, [screenshots]);

  // ── Helpers para strings en arrays ────────────────────

  const addToArray = (
    value: string,
    setter: React.Dispatch<React.SetStateAction<string[]>>,
    inputSetter: React.Dispatch<React.SetStateAction<string>>,
    current: string[],
  ) => {
    const trimmed = value.trim();
    if (trimmed && !current.includes(trimmed)) setter([...current, trimmed]);
    inputSetter("");
  };

  const removeFromArray = (
    item: string,
    setter: React.Dispatch<React.SetStateAction<string[]>>,
    current: string[],
  ) => setter(current.filter((x) => x !== item));

  const handleKeyEnter = (
    e: React.KeyboardEvent,
    value: string,
    setter: React.Dispatch<React.SetStateAction<string[]>>,
    inputSetter: React.Dispatch<React.SetStateAction<string>>,
    current: string[],
  ) => {
    if (e.key === "Enter") {
      e.preventDefault();
      addToArray(value, setter, inputSetter, current);
    }
  };

  // ── Submit ────────────────────────────────────────────

  const handleFormSubmit = handleSubmit(async (data: ProjectFormData) => {
    // Subir imagen principal de galería si hay un archivo nuevo
    if (mainScreenshotFile) {
      data.main_screenshot_url = await uploadToCloudinary(mainScreenshotFile);
    }

    // Subir screenshots secundarias y agregar sus URLs al array existente
    if (screenshotFiles.length > 0) {
      const newUrls = await Promise.all(screenshotFiles.map((s) => uploadToCloudinary(s.file)));
      data.screenshots = [...(data.screenshots ?? []), ...newUrls];
    }

    onSubmit(data, { heroFile: heroFile ?? undefined, cardFile: cardFile ?? undefined });
  });

  // ── Subcomponente: selector de imagen via diálogo nativo ─────────────────

  const ImagePicker = ({
    preview,
    onSelect,
    onClear,
    labelText,
  }: {
    preview: string;
    onSelect: () => void;
    onClear: () => void;
    labelText: string;
  }) => (
    <div>
      <label className={label}>{labelText}</label>
      {preview ? (
        <div className="relative mt-1">
          <img src={preview} alt="preview" className="h-32 w-full object-cover rounded-lg border border-gray-700" />
          <button
            type="button"
            onClick={onClear}
            className="absolute top-2 right-2 bg-gray-900/80 hover:bg-gray-900 text-gray-400 hover:text-red-400 rounded-full p-1 transition-colors"
          >
            <X size={13} />
          </button>
          <button
            type="button"
            onClick={onSelect}
            className="absolute bottom-2 right-2 bg-gray-900/80 hover:bg-gray-800 text-gray-400 text-xs px-2 py-1 rounded transition-colors"
          >
            Cambiar
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={onSelect}
          className="mt-1 w-full border-2 border-dashed border-gray-700 hover:border-gray-500 rounded-lg py-5 flex flex-col items-center gap-2 text-gray-500 hover:text-gray-400 transition-colors"
        >
          <ImagePlus size={22} />
          <span className="text-xs">Seleccionar imagen</span>
        </button>
      )}
    </div>
  );

  // ── Render de tabs ────────────────────────────────────

  return (
    <form onSubmit={handleFormSubmit} className="space-y-4">

      {/* Tab bar */}
      <div className="flex gap-1 border-b border-gray-700 pb-0 overflow-x-auto">
        {TABS.map((tab) => (
          <button
            key={tab}
            type="button"
            onClick={() => setActiveTab(tab)}
            className={`px-3 py-2 text-xs font-mono whitespace-nowrap transition-colors rounded-t-md ${
              activeTab === tab
                ? "bg-gray-700 text-blue-400 border-b-2 border-blue-400"
                : "text-gray-500 hover:text-gray-300"
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* ===== Tab: General ===== */}
      {activeTab === "General" && (
        <div className="space-y-4">
          {/* Título */}
          <div>
            <label className={label}>Título *</label>
            <input {...register("title")} className={input} />
            {errors.title && <p className="text-red-400 text-xs mt-1">{errors.title.message}</p>}
          </div>

          {/* Slug */}
          <div>
            <div className="flex justify-between">
              <label className={label}>Slug *</label>
              {!slugLocked && <span className="text-xs text-blue-400 font-mono">auto</span>}
            </div>
            <input
              {...register("slug")}
              className={input}
              onChange={(e) => {
                register("slug").onChange(e);
                setSlugLocked(e.target.value !== "" && e.target.value !== generateSlug(titleValue ?? ""));
              }}
            />
            {errors.slug && <p className="text-red-400 text-xs mt-1">{errors.slug.message}</p>}
          </div>

          {/* Order + Type */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className={label}>Orden</label>
              <input
                type="number"
                {...register("order", { setValueAs: (v: unknown) => v === "" ? 0 : Number(v) || 0 })}
                className={input}
              />
            </div>
            <div>
              <label className={label}>Tipo de proyecto</label>
              <select {...register("project_type")} className={input}>
                <option value="web_app">Web App</option>
                <option value="mobile_app">Mobile App</option>
                <option value="api">API</option>
                <option value="library">Library</option>
                <option value="tool">Tool</option>
              </select>
            </div>
          </div>

          {/* Visibilidad */}
          <div className="flex gap-6">
            <label className="flex items-center gap-2 cursor-pointer">
              <input type="checkbox" {...register("is_published")} className="accent-blue-500" />
              <span className="text-xs text-gray-300 font-mono">Publicado</span>
            </label>
            <label className="flex items-center gap-2 cursor-pointer">
              <input type="checkbox" {...register("is_featured")} className="accent-blue-500" />
              <span className="text-xs text-gray-300 font-mono">Destacado</span>
            </label>
          </div>

          {/* SEO (agrupado aquí para no necesitar tab extra) */}
          <p className={sectionTitle}>// SEO</p>
          <div>
            <label className={label}>Título SEO (deja vacío para usar el título)</label>
            <input {...register("seo_title")} className={input} placeholder={watch("title")} />
          </div>
          <div>
            <label className={label}>Descripción SEO (deja vacío para usar el tagline)</label>
            <textarea {...register("seo_description")} rows={2} className={input} />
          </div>
        </div>
      )}

      {/* ===== Tab: Hero ===== */}
      {activeTab === "Hero" && (
        <div className="space-y-4">
          <div>
            <label className={label}>Tagline (1-2 líneas para el hero)</label>
            <textarea {...register("tagline")} rows={2} className={input} />
          </div>

          <ImagePicker
            preview={heroPreview}
            onSelect={() => selectImage("hero")}
            onClear={() => { setHeroFile(null); setHeroPreview(""); }}
            labelText="Imagen hero (derecha del título)"
          />

          <p className={sectionTitle}>// CTAs</p>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className={label}>Texto CTA primario</label>
              <input {...register("cta_primary_label")} placeholder="live_demo() →" className={input} />
            </div>
            <div>
              <label className={label}>URL CTA primario</label>
              <input {...register("cta_primary_url")} placeholder="https://..." className={input} />
              {errors.cta_primary_url && <p className="text-red-400 text-xs mt-1">{errors.cta_primary_url.message}</p>}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className={label}>Texto CTA secundario</label>
              <input {...register("cta_secondary_label")} placeholder="source_code() →" className={input} />
            </div>
            <div>
              <label className={label}>URL CTA secundario</label>
              <input {...register("cta_secondary_url")} placeholder="https://..." className={input} />
              {errors.cta_secondary_url && <p className="text-red-400 text-xs mt-1">{errors.cta_secondary_url.message}</p>}
            </div>
          </div>

          <div>
            <label className={label}>Repositorio (GitHub)</label>
            <input {...register("repository_url")} placeholder="https://github.com/..." className={input} />
            {errors.repository_url && <p className="text-red-400 text-xs mt-1">{errors.repository_url.message}</p>}
          </div>
        </div>
      )}

      {/* ===== Tab: Metadata ===== */}
      {activeTab === "Metadata" && (
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className={label}>Rol desempeñado</label>
              <input {...register("role")} placeholder="Full-Stack Developer" className={input} />
            </div>
            <div>
              <label className={label}>Año</label>
              <input
                type="number"
                {...register("year", {
                  setValueAs: (v: unknown) => {
                    const n = Number(v);
                    return v === "" || v == null || isNaN(n) ? null : n;
                  },
                })}
                placeholder="2025"
                className={input}
              />
            </div>
          </div>

          <div>
            <label className={label}>Estado del proyecto</label>
            <select
              {...register("status", { setValueAs: (v: string) => v === "" ? undefined : v })}
              className={input}
            >
              <option value="">— Sin especificar —</option>
              <option value="Live">Live</option>
              <option value="In Development">In Development</option>
              <option value="Deprecated">Deprecated</option>
              <option value="Open Source">Open Source</option>
            </select>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className={label}>Cliente / Contexto</label>
              <input {...register("client")} placeholder="Personal Project" className={input} />
            </div>
            <div>
              <label className={label}>Duración</label>
              <input {...register("duration")} placeholder="3 Months" className={input} />
            </div>
          </div>

          <div>
            <label className={label}>Tamaño del equipo</label>
            <input {...register("team_size")} placeholder="Solo / 2 developers" className={input} />
          </div>
        </div>
      )}

      {/* ===== Tab: Contenido ===== */}
      {activeTab === "Contenido" && (
        <div className="space-y-4">
          <p className={sectionTitle}>// The Challenge</p>
          <div>
            <label className={label}>Párrafo 1 — Contexto del reto</label>
            <textarea {...register("challenge_paragraph_1")} rows={3} className={input} />
          </div>
          <div>
            <label className={label}>Párrafo 2 — Solución adoptada</label>
            <textarea {...register("challenge_paragraph_2")} rows={3} className={input} />
          </div>

          {/* Key Challenges */}
          <p className={sectionTitle}>// Key Challenges (máx 4)</p>
          <div className="flex flex-wrap gap-2 min-h-7">
            {keyChallenges.map((c) => (
              <span key={c} className={tagStyle}>
                {c}
                <button type="button" onClick={() => removeFromArray(c, setKeyChallenges, keyChallenges)}>
                  <X size={10} />
                </button>
              </span>
            ))}
          </div>
          {keyChallenges.length < 4 && (
            <div className="flex gap-2">
              <input
                value={challengeInput}
                onChange={(e) => setChallengeInput(e.target.value)}
                onKeyDown={(e) => handleKeyEnter(e, challengeInput, setKeyChallenges, setChallengeInput, keyChallenges)}
                placeholder="Reto clave — Enter para agregar"
                className={`${input} mt-0 flex-1`}
              />
              <button
                type="button"
                onClick={() => addToArray(challengeInput, setKeyChallenges, setChallengeInput, keyChallenges)}
                className="mt-0 px-3 bg-gray-700 hover:bg-gray-600 rounded-lg text-gray-300 transition-colors"
              >
                <Plus size={14} />
              </button>
            </div>
          )}

          {/* Key Features */}
          <p className={sectionTitle}>// Key Features (máx 3)</p>
          {features.map((feat, i) => (
            <div key={i} className="bg-gray-800 rounded-lg p-3 space-y-2 relative">
              <span className="text-red-400 font-mono text-xs font-bold">0{i + 1}</span>
              <button
                type="button"
                onClick={() => setFeatures(features.filter((_, idx) => idx !== i))}
                className="absolute top-3 right-3 text-gray-600 hover:text-red-400 transition-colors"
              >
                <Trash2 size={13} />
              </button>
              <input
                value={feat.title}
                onChange={(e) =>
                  setFeatures(features.map((f, idx) => (idx === i ? { ...f, title: e.target.value } : f)))
                }
                placeholder="Título de la feature"
                className={`${input} mt-0`}
              />
              <textarea
                value={feat.description}
                onChange={(e) =>
                  setFeatures(features.map((f, idx) => (idx === i ? { ...f, description: e.target.value } : f)))
                }
                rows={2}
                placeholder="Qué hace y cómo se implementó (2-3 oraciones)"
                className={`${input} mt-0`}
              />
            </div>
          ))}
          {features.length < 3 && (
            <button
              type="button"
              onClick={() => setFeatures([...features, { title: "", description: "" }])}
              className="flex items-center gap-1 text-xs text-blue-400 hover:text-blue-300 font-mono transition-colors"
            >
              <Plus size={13} /> Añadir feature
            </button>
          )}
        </div>
      )}

      {/* ===== Tab: Tech Stack ===== */}
      {activeTab === "Tech Stack" && (
        <div className="space-y-4">
          <p className="text-xs text-gray-500 font-mono">Organiza las tecnologías por categoría (FRONTEND, BACKEND, DEVOPS…)</p>

          {techCategories.map((cat, ci) => (
            <div key={ci} className="bg-gray-800 rounded-lg p-3 space-y-2">
              <div className="flex items-center justify-between">
                <input
                  value={cat.category}
                  onChange={(e) =>
                    setTechCategories(techCategories.map((c, idx) => (idx === ci ? { ...c, category: e.target.value } : c)))
                  }
                  placeholder="Categoría (ej: FRONTEND)"
                  className={`${input} mt-0 uppercase`}
                />
                <button
                  type="button"
                  onClick={() => setTechCategories(techCategories.filter((_, idx) => idx !== ci))}
                  className="ml-2 text-gray-600 hover:text-red-400 transition-colors shrink-0"
                >
                  <Trash2 size={13} />
                </button>
              </div>

              {/* Techs de esta categoría */}
              <div className="flex flex-wrap gap-1 min-h-6">
                {cat.technologies.map((tech) => (
                  <span key={tech} className={tagStyle}>
                    {tech}
                    <button
                      type="button"
                      onClick={() =>
                        setTechCategories(
                          techCategories.map((c, idx) =>
                            idx === ci ? { ...c, technologies: c.technologies.filter((t) => t !== tech) } : c,
                          ),
                        )
                      }
                    >
                      <X size={10} />
                    </button>
                  </span>
                ))}
              </div>

              {/* Input para agregar tech */}
              <input
                value={cat.techInput}
                onChange={(e) =>
                  setTechCategories(techCategories.map((c, idx) => (idx === ci ? { ...c, techInput: e.target.value } : c)))
                }
                onKeyDown={(e) => {
                  if (e.key === "Enter") {
                    e.preventDefault();
                    const val = cat.techInput.trim();
                    if (val && !cat.technologies.includes(val)) {
                      setTechCategories(
                        techCategories.map((c, idx) =>
                          idx === ci ? { ...c, technologies: [...c.technologies, val], techInput: "" } : c,
                        ),
                      );
                    } else {
                      setTechCategories(techCategories.map((c, idx) => (idx === ci ? { ...c, techInput: "" } : c)));
                    }
                  }
                }}
                placeholder="Tecnología — Enter para agregar"
                className={`${input} mt-0`}
              />
            </div>
          ))}

          {/* Añadir categoría */}
          <div className="flex gap-2">
            <input
              value={newCategoryInput}
              onChange={(e) => setNewCategoryInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  e.preventDefault();
                  if (newCategoryInput.trim()) {
                    setTechCategories([...techCategories, { category: newCategoryInput.trim().toUpperCase(), technologies: [], techInput: "" }]);
                    setNewCategoryInput("");
                  }
                }
              }}
              placeholder="Nueva categoría"
              className={`${input} mt-0 flex-1`}
            />
            <button
              type="button"
              onClick={() => {
                if (newCategoryInput.trim()) {
                  setTechCategories([...techCategories, { category: newCategoryInput.trim().toUpperCase(), technologies: [], techInput: "" }]);
                  setNewCategoryInput("");
                }
              }}
              className="px-3 bg-blue-600 hover:bg-blue-700 rounded-lg text-white transition-colors"
            >
              <Plus size={14} />
            </button>
          </div>
        </div>
      )}

      {/* ===== Tab: Galería & Card ===== */}
      {activeTab === "Galería & Card" && (
        <div className="space-y-4">
          <p className={sectionTitle}>// Galería</p>

          <ImagePicker
            preview={mainScreenshotPreview}
            onSelect={() => selectImage("main")}
            onClear={() => { setMainScreenshotFile(null); setMainScreenshotPreview(""); setValue("main_screenshot_url", ""); }}
            labelText="Imagen principal de galería (screenshot grande)"
          />

          {/* Screenshots secundarias */}
          <div>
            <label className={label}>Screenshots secundarias</label>

            {/* URLs ya guardadas en DB */}
            {screenshots.length > 0 && (
              <div className="grid grid-cols-3 gap-2 mt-2 mb-2">
                {screenshots.map((url, i) => (
                  <div key={i} className="relative">
                    <img src={url} alt={`screenshot ${i + 1}`} className="h-20 w-full object-cover rounded-lg border border-gray-700" />
                    <button
                      type="button"
                      onClick={() => removeFromArray(url, setScreenshots, screenshots)}
                      className="absolute top-1 right-1 bg-gray-900/80 hover:bg-gray-900 text-gray-400 hover:text-red-400 rounded-full p-0.5 transition-colors"
                    >
                      <X size={11} />
                    </button>
                  </div>
                ))}
              </div>
            )}

            {/* Nuevas imágenes pendientes de subir */}
            {screenshotFiles.length > 0 && (
              <div className="grid grid-cols-3 gap-2 mt-2 mb-2">
                {screenshotFiles.map((s, i) => (
                  <div key={i} className="relative">
                    <img src={s.preview} alt={`nueva ${i + 1}`} className="h-20 w-full object-cover rounded-lg border border-blue-500/50" />
                    <button
                      type="button"
                      onClick={() => removeScreenshotFile(i)}
                      className="absolute top-1 right-1 bg-gray-900/80 hover:bg-gray-900 text-gray-400 hover:text-red-400 rounded-full p-0.5 transition-colors"
                    >
                      <X size={11} />
                    </button>
                    <span className="absolute bottom-1 left-1 text-xs bg-blue-600/80 text-white px-1 rounded font-mono">nuevo</span>
                  </div>
                ))}
              </div>
            )}

            <button
              type="button"
              onClick={addScreenshot}
              className="mt-1 w-full border-2 border-dashed border-gray-700 hover:border-gray-500 rounded-lg py-3 flex items-center justify-center gap-2 text-gray-500 hover:text-gray-400 transition-colors text-xs font-mono"
            >
              <ImagePlus size={16} /> Agregar screenshot
            </button>
          </div>

          {/* Métricas */}
          <div>
            <label className={label}>Métricas de impacto (máx 4)</label>
            <div className="flex flex-wrap gap-2 min-h-7 mt-1 mb-2">
              {metrics.map((m) => (
                <span key={m} className={tagStyle}>
                  {m}
                  <button type="button" onClick={() => removeFromArray(m, setMetrics, metrics)}><X size={10} /></button>
                </span>
              ))}
            </div>
            {metrics.length < 4 && (
              <div className="flex gap-2">
                <input
                  value={metricInput}
                  onChange={(e) => setMetricInput(e.target.value)}
                  onKeyDown={(e) => handleKeyEnter(e, metricInput, setMetrics, setMetricInput, metrics)}
                  placeholder="Ej: 50k usuarios activos"
                  className={`${input} mt-0 flex-1`}
                />
                <button type="button" onClick={() => addToArray(metricInput, setMetrics, setMetricInput, metrics)} className="px-3 bg-gray-700 hover:bg-gray-600 rounded-lg text-gray-300 transition-colors">
                  <Plus size={14} />
                </button>
              </div>
            )}
          </div>

          <p className={sectionTitle}>// Card del listado</p>

          <ImagePicker
            preview={cardPreview}
            onSelect={() => selectImage("card")}
            onClear={() => { setCardFile(null); setCardPreview(""); }}
            labelText="Thumbnail de la card (diferente al hero)"
          />

          <div>
            <label className={label}>Descripción corta para la card (máx ~120 chars)</label>
            <input {...register("card_short_description")} maxLength={120} className={input} />
          </div>

          {/* Tags */}
          <div>
            <label className={label}>Tags visibles en la card</label>
            <div className="flex flex-wrap gap-2 min-h-7 mt-1 mb-2">
              {tags.map((t) => (
                <span key={t} className={tagStyle}>
                  {t}
                  <button type="button" onClick={() => removeFromArray(t, setTags, tags)}><X size={10} /></button>
                </span>
              ))}
            </div>
            <div className="flex gap-2">
              <input
                value={tagInput}
                onChange={(e) => setTagInput(e.target.value)}
                onKeyDown={(e) => handleKeyEnter(e, tagInput, setTags, setTagInput, tags)}
                placeholder="Tag — Enter para agregar"
                className={`${input} mt-0 flex-1`}
              />
              <button type="button" onClick={() => addToArray(tagInput, setTags, setTagInput, tags)} className="px-3 bg-gray-700 hover:bg-gray-600 rounded-lg text-gray-300 transition-colors">
                <Plus size={14} />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── Submit ── */}
      <div className="pt-2 border-t border-gray-700">
        <button
          type="submit"
          className="w-full bg-blue-500 hover:bg-blue-600 text-white py-2.5 rounded-lg font-medium text-sm transition-colors"
        >
          Guardar proyecto
        </button>
      </div>
    </form>
  );
};

export default ProjectForm;
