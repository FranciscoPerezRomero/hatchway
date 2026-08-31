import { Pencil, Trash2, Globe, ExternalLink } from "lucide-react";
import { Project } from "../types/project";

interface Props {
  project: Project;
  onEdit: (project: Project) => void;
  onDelete: (id: number) => void;
}

const PROJECT_TYPE_LABEL: Record<Project["project_type"], string> = {
  web_app: "Web App",
  mobile_app: "Mobile",
  api: "API",
  library: "Library",
  tool: "Tool",
};

const STATUS_COLORS: Record<string, string> = {
  Live: "bg-green-900 text-green-300",
  "In Development": "bg-blue-900 text-blue-300",
  Deprecated: "bg-yellow-900 text-yellow-300",
  "Open Source": "bg-purple-900 text-purple-300",
};

const ProjectCard = ({ project, onEdit, onDelete }: Props) => {
  const handleDelete = () => {
    if (window.confirm(`¿Eliminar "${project.title}"?`)) {
      onDelete(project.id);
    }
  };

  const thumbnail = project.card_thumbnail_url ?? project.hero_image_url;

  return (
    <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden group">

      {/* Thumbnail */}
      {thumbnail ? (
        <img
          src={thumbnail}
          alt={project.title}
          className="w-full h-36 object-cover"
        />
      ) : (
        <div className="w-full h-36 bg-gray-800 flex items-center justify-center text-gray-600 text-xs font-mono">
          // sin_imagen()
        </div>
      )}

      <div className="p-4">
        {/* Header: título + acciones */}
        <div className="flex items-start justify-between gap-2 mb-2">
          <h3 className="text-white font-semibold text-sm leading-tight">{project.title}</h3>
          <div className="flex items-center gap-1 shrink-0 opacity-0 group-hover:opacity-100 transition-opacity">
            <button
              onClick={() => onEdit(project)}
              className="p-1 text-gray-500 hover:text-blue-400 transition-colors"
              title="Editar"
            >
              <Pencil size={13} />
            </button>
            <button
              onClick={handleDelete}
              className="p-1 text-gray-500 hover:text-red-400 transition-colors"
              title="Eliminar"
            >
              <Trash2 size={13} />
            </button>
          </div>
        </div>

        {/* Badges: tipo, published, live status */}
        <div className="flex flex-wrap gap-1 mb-2">
          <span className="text-xs bg-gray-700 text-gray-300 px-2 py-0.5 rounded-full">
            {PROJECT_TYPE_LABEL[project.project_type]}
          </span>
          <span
            className={`text-xs px-2 py-0.5 rounded-full ${
              project.is_published
                ? "bg-green-900 text-green-300"
                : "bg-gray-700 text-gray-400"
            }`}
          >
            {project.is_published ? "Publicado" : "Borrador"}
          </span>
          {project.status && (
            <span className={`text-xs px-2 py-0.5 rounded-full ${STATUS_COLORS[project.status] ?? "bg-gray-700 text-gray-300"}`}>
              {project.status}
            </span>
          )}
        </div>

        {/* Tagline o short description */}
        {(project.card_short_description ?? project.tagline) && (
          <p className="text-gray-400 text-xs line-clamp-2 mb-2">
            {project.card_short_description ?? project.tagline}
          </p>
        )}

        {/* Links rápidos */}
        <div className="flex gap-2 mt-auto">
          {project.repository_url && (
            <a
              href={project.repository_url}
              target="_blank"
              rel="noreferrer"
              className="text-gray-500 hover:text-gray-300 transition-colors"
              title="Repositorio"
            >
              <ExternalLink size={13} />
            </a>
          )}
          {project.cta_primary_url && (
            <a
              href={project.cta_primary_url}
              target="_blank"
              rel="noreferrer"
              className="text-gray-500 hover:text-gray-300 transition-colors"
              title="Ver en vivo"
            >
              <Globe size={13} />
            </a>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProjectCard;
