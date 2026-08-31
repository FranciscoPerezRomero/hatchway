// ── Tipos anidados ─────────────────────────────────────────────────────────────

export interface TechCategory {
  category: string;
  technologies: string[];
}

export interface Feature {
  title: string;
  description: string;
}

// ── Proyecto completo (respuesta de la API) ────────────────────────────────────

export interface Project {
  id: number;

  // Identificación
  slug: string;
  order: number;
  project_type: "web_app" | "mobile_app" | "api" | "library" | "tool";
  is_published: boolean;
  is_featured: boolean;
  created_at: string;
  updated_at: string;

  // Hero
  title: string;
  tagline: string | null;
  hero_image_url: string | null;
  cta_primary_label: string | null;
  cta_primary_url: string | null;
  cta_secondary_label: string | null;
  cta_secondary_url: string | null;
  repository_url: string | null;

  // Metadata Strip
  role: string | null;
  year: number | null;
  status: "Live" | "In Development" | "Deprecated" | "Open Source" | null;
  client: string | null;
  duration: string | null;
  team_size: string | null;

  // About / Challenge
  challenge_paragraph_1: string | null;
  challenge_paragraph_2: string | null;
  key_challenges: string[];

  // Tech Stack y Features
  tech_stack: TechCategory[];
  features: Feature[];

  // Métricas
  metrics: string[];

  // Galería
  main_screenshot_url: string | null;
  screenshots: string[];

  // Card del listado
  card_thumbnail_url: string | null;
  card_short_description: string | null;
  tags: string[];

  // SEO
  seo_title: string | null;
  seo_description: string | null;
}

// ── Payload de creación / actualización (todos opcionales excepto title y slug) ─

export interface ProjectCreate {
  title: string;
  slug: string;
  order?: number;
  project_type?: "web_app" | "mobile_app" | "api" | "library" | "tool";
  is_published?: boolean;
  is_featured?: boolean;
  tagline?: string;
  hero_image_url?: string;
  cta_primary_label?: string;
  cta_primary_url?: string;
  cta_secondary_label?: string;
  cta_secondary_url?: string;
  repository_url?: string;
  role?: string;
  year?: number | null;
  status?: "Live" | "In Development" | "Deprecated" | "Open Source" | null;
  client?: string;
  duration?: string;
  team_size?: string;
  challenge_paragraph_1?: string;
  challenge_paragraph_2?: string;
  key_challenges?: string[];
  tech_stack?: TechCategory[];
  features?: Feature[];
  metrics?: string[];
  main_screenshot_url?: string;
  screenshots?: string[];
  card_thumbnail_url?: string;
  card_short_description?: string;
  tags?: string[];
  seo_title?: string;
  seo_description?: string;
}
