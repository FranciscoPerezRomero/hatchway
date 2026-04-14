import { useForm, Resolver } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useState, useEffect } from "react";

//* Schema validation
const projectSchema = z.object({
  title: z.string().min(1, "El titulo es requerido"),
  slug: z.string().min(1, "El slug es requerido"),
  tagline: z.string().optional(),
  description: z.string().optional(),
  status: z.enum(["draft", "published", "archived"]),
  tech_stack: z.array(z.string()).default([]),
  github_url: z.string().url().optional().or(z.literal("")),
  live_url: z.string().url().optional().or(z.literal("")),
  demo_url: z.string().url().optional().or(z.literal("")),
  thumbnail_url: z.string().optional(),
});

type ProjectFormData = z.infer<typeof projectSchema>;

interface Props {
  onSubmit: (data: ProjectFormData) => void;
  defaultValues?: Partial<ProjectFormData>;
}

const ProjectForm = ({ onSubmit, defaultValues }: Props) => {
  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<ProjectFormData>({
    resolver: zodResolver(projectSchema) as Resolver<ProjectFormData>,
    defaultValues: defaultValues || { status: "draft", tech_stack: [] },
  });

  const [techInput, setTechInput] = useState("");
  const [techStack, setTechStack] = useState<string[]>(
    defaultValues?.tech_stack ?? [],
  );
  const inputClass =
    "w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white placeholder:text-gray-600 focus:outline-none focus:border-blue-500";

  useEffect(() => {
    setValue("tech_stack", techStack);
  }, [techStack]);

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      {/* Título */}
      <div>
        <label className="text-sm text-gray-400">Título</label>
        <input
          {...register("title")}
          className="w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-blue-500"
        />
        {errors.title && (
          <p className="text-red-400 text-xs mt-1">{errors.title.message}</p>
        )}
      </div>

      {/* Slug */}
      <div>
        <label className="text-sm text-gray-400">Slug</label>
        <input
          {...register("slug")}
          className="w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-blue-500"
        />
        {errors.slug && (
          <p className="text-red-400 text-xs mt-1">{errors.slug.message}</p>
        )}
      </div>

      {/* Status */}
      <div>
        <label className="text-sm text-gray-400">Status</label>
        <select
          {...register("status")}
          className="w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-blue-500"
        >
          <option value="draft">Draft</option>
          <option value="published">Published</option>
          <option value="archived">Archived</option>
        </select>
      </div>

      {/* Tagline */}
      <div>
        <label className="text-sm text-gray-400">Tagline</label>
        <input
          {...register("tagline")}
          className="w-full mt-1 bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-blue-500"
        />
      </div>

      {/* Tech list stack  */}
      <div>
        <label className="flex flex-wrap gap-2 mt-1 mb-2">
          {techStack.map((tech) => (
            <span
              className="flex items-center gap-1 bg-gray-700 text-gray-200 text-xs px-2 py-1 rounded-full"
              key={tech}
            >
              {tech}
              <button
                type="button"
                onClick={() =>
                  setTechStack(techStack.filter((t) => t !== tech))
                }
              >
                {" "}
                x{" "}
              </button>
            </span>
          ))}
        </label>
      </div>
      <input
        value={techInput}
        onChange={(e) => setTechInput(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter") {
            e.preventDefault();
            const value = techInput.trim();
            if (value && !techStack.includes(value)) {
              setTechStack([...techStack, value]);
            }
            setTechInput("");
          }
        }}
        placeholder="Escribe y presiona enter"
        className={inputClass}
      />

      {/* URLs */}
      <div>
        <label className="text-sm text-gray-400">GitHub URL</label>
        <input
          {...register("github_url")}
          placeholder="https://github.com/usuario/repo"
          className={inputClass}
        />
        {errors.github_url && (
          <p className="text-red-400 text-xs mt-1">
            {errors.github_url.message}
          </p>
        )}
      </div>

      <div>
        <label className="text-sm text-gray-400">Live URL</label>
        <input
          {...register("live_url")}
          placeholder="https://tuproyecto.com"
          className={inputClass}
        />
        {errors.live_url && (
          <p className="text-red-400 text-xs mt-1">{errors.live_url.message}</p>
        )}
      </div>

      <div>
        <label className="text-sm text-gray-400">Demo URL</label>
        <input
          {...register("demo_url")}
          placeholder="https://demo.tuproyecto.com"
          className={inputClass}
        />
        {errors.demo_url && (
          <p className="text-red-400 text-xs mt-1">{errors.demo_url.message}</p>
        )}
      </div>

      {/* Description  */}
      <div>
        <label className="text-sm text-gray-400">Descripción</label>
        <textarea
          {...register("description")}
          rows={4}
          className="w-full mt-1 bg-gray800 border border-gray-700 rounded-lg px-3 py-2 text-white focus:outline-none"
        />
      </div>

      {/* Botón */}
      <button
        type="submit"
        className="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-medium transition-colors"
      >
        Guardar proyecto
      </button>
    </form>
  );
};

export default ProjectForm;
