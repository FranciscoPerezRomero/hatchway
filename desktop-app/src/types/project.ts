export interface Project {
  id: number;
  title: string;
  slug: string;
  tagline: string | null;
  description: string | null;
  status: "draft" | "published" | "archived";
  tech_stack: string[];
  github_url: string | null;
  live_url: string | null;
  demo_url: string | null;
  thumbnail_url: string | null;
  created_at: string;
  updated_at: string;
}


export type ProjectCreate = Omit<Project, "id" | "created_at" | "updated_at">;