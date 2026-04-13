import { useEffect } from "react";
import { Layers } from "lucide-react";
import { Toaster } from "react-hot-toast";
import useProjectStore from "./store/projectStore";
import Dashboard from "./pages/Dashboard";

function App() {
  const fetchProjects = useProjectStore((state) => state.fetchProjects);

  useEffect(() => {
    fetchProjects();
  }, []);

  return (
    <div className="flex h-screen bg-gray-950 text-gray-100">
      {/* Sidebar */}
      <aside className="w-64 bg-gray-900 border-r border-gray-800 flex flex-col">
        <div className="p-6 border-b border-gray-800">
          <div className="flex items-center gap-3">
            <Layers className="text-blue-400" size={24} />
            <span className="text-xl font-bold text-white">Hatchway</span>
          </div>
        </div>
        <nav className="p-4">
          <p className="text-blue-400 bg-blue-400/10 px-3 py-2 rounded-lg text-sm font-medium">
            Proyectos
          </p>
        </nav>
      </aside>

      {/* Contenido principal */}
      <main className="flex-1 overflow-auto">
        <Dashboard />
      </main>

      <Toaster position="bottom-right" />
    </div>
  );
}

export default App;