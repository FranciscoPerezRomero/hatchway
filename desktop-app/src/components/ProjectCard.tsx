import { Project } from "../types/project";

interface Props {
  project: Project;
}

const ProjectCard = ({ project }: Props) => {
  const statusColors = {
    draft: "bg-gray-700 text-gray-300",
    published: "bg-green-900 text-green-300",
    archived: "bg-yellow-900 text-yellow-300",
  };
  return (
    <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
      <div className="flex items-start justify-between mb-2">
        <h3 className="text-white font-semibold">{project.title}</h3>
        <span
          className={`text-xs px-2 py-1 rounded-full ${statusColors[project.status]}`}
        >
          {project.status}
        </span>
      </div>
      <p className="text-gray-400 text-sm">{project.tagline}</p>
    </div>
  );
};

export default ProjectCard;
