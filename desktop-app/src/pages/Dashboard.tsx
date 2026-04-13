import ProjectCard from "../components/ProjectCard";
import useProjectStore from "../store/projectStore";
import { Plus } from "lucide-react";

const Dashboard = () => {
  const { projects, loading, error } = useProjectStore();

  return (
    <div className="p-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold text-white">Mis Proyectos</h1>
        <button className="flex items-center gap-2 bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
          <Plus size={16} />
          Nuevo proyecto
        </button>
      </div>

      {/* Estados */}
      {loading && <p className="text-gray-400">Cargando...</p>}
      {error && <p className="text-red-400">{error}</p>}

      {/* Lista */}
      {!loading && !error && projects.length === 0 && (
        <p className="text-gray-500">No hay proyectos aún.</p>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {projects.map((project) => (
          <ProjectCard key={project.id} project={project} />
        ))}
      </div>
    </div>
  );
};

export default Dashboard;
