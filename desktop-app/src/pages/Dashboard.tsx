import { useState } from "react";
import { toast } from "react-hot-toast";
import ProjectCard from "../components/ProjectCard";
import Modal from "../components/Modal";
import useProjectStore from "../store/projectStore";
import ProjectForm, { ProjectFormFiles } from "../components/ProjectForm";
import { Project, ProjectCreate } from "../types/project";
import { uploadImage } from "../api/endpoints";
import { Plus } from "lucide-react";

const Dashboard = () => {
  const { projects, loading, error, createProject, updateProject, deleteProject, setImage } =
    useProjectStore();
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingProject, setEditingProject] = useState<Project | null>(null);

  // *Sube hero y/o card thumbnail si se adjuntaron archivos
  const handleImageUploads = async (id: number, files: ProjectFormFiles) => {
    if (files.heroFile) {
      try {
        const { data } = await uploadImage(id, files.heroFile, "hero");
        setImage(id, "hero_image_url", data.url);
      } catch {
        toast.error("Proyecto guardado, pero la imagen hero no se pudo subir.");
      }
    }
    if (files.cardFile) {
      try {
        const { data } = await uploadImage(id, files.cardFile, "card");
        setImage(id, "card_thumbnail_url", data.url);
      } catch {
        toast.error("Proyecto guardado, pero el thumbnail no se pudo subir.");
      }
    }
  };

  const handleCreate = async (data: ProjectCreate, files: ProjectFormFiles) => {
    const created = await createProject(data);
    if (created) await handleImageUploads(created.id, files);
    setShowCreateForm(false);
  };

  const handleEdit = async (data: ProjectCreate, files: ProjectFormFiles) => {
    if (!editingProject) return;
    await updateProject(editingProject.id, data);
    await handleImageUploads(editingProject.id, files);
    setEditingProject(null);
  };

  return (
    <div className="p-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold text-white">Mis Proyectos</h1>
        <button
          onClick={() => setShowCreateForm(true)}
          className="flex items-center gap-2 bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors"
        >
          <Plus size={16} />
          Nuevo proyecto
        </button>
      </div>

      {/* Modal: crear */}
      {showCreateForm && (
        <Modal title="Nuevo proyecto" onClose={() => setShowCreateForm(false)}>
          <ProjectForm onSubmit={handleCreate} />
        </Modal>
      )}

      {/* Modal: editar */}
      {editingProject && (
        <Modal title="Editar proyecto" onClose={() => setEditingProject(null)}>
          <ProjectForm onSubmit={handleEdit} defaultValues={editingProject} />
        </Modal>
      )}

      {/* Estados */}
      {loading && <p className="text-gray-400 text-sm font-mono">// cargando...</p>}
      {error && <p className="text-red-400 text-sm font-mono">// {error}</p>}

      {!loading && !error && projects.length === 0 && (
        <p className="text-gray-500 text-sm font-mono">// no_hay_proyectos()</p>
      )}

      {/* Grid de proyectos */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {projects.map((project) => (
          <ProjectCard
            key={project.id}
            project={project}
            onEdit={setEditingProject}
            onDelete={deleteProject}
          />
        ))}
      </div>
    </div>
  );
};

export default Dashboard;
