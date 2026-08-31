import { create } from 'zustand'
import { Project, ProjectCreate } from '../types/project'
import * as api from '../api/endpoints'

interface ProjectStore {
  projects: Project[]
  loading: boolean
  error: string | null

  fetchProjects: () => Promise<void>
  createProject: (data: ProjectCreate) => Promise<Project | null>
  updateProject: (id: number, data: ProjectCreate) => Promise<void>
  deleteProject: (id: number) => Promise<void>
  // *Actualiza una URL de imagen en el estado local tras subirla a Cloudinary
  setImage: (id: number, field: 'hero_image_url' | 'card_thumbnail_url', url: string) => void
}

const useProjectStore = create<ProjectStore>((set) => ({
  projects: [],
  loading: false,
  error: null,

  // *Carga todos los proyectos desde la API (sin filtros — vista admin)
  fetchProjects: async () => {
    set({ loading: true, error: null })
    try {
      const response = await api.getProjects()
      set({ projects: response.data, loading: false })
    } catch {
      set({ error: 'Error al cargar proyectos', loading: false })
    }
  },

  // *Crea un proyecto y lo agrega al array local
  createProject: async (data) => {
    set({ loading: true, error: null })
    try {
      const response = await api.createProject(data)
      set((state) => ({
        projects: [...state.projects, response.data],
        loading: false,
      }))
      return response.data
    } catch {
      set({ error: 'Error al crear proyecto', loading: false })
      return null
    }
  },

  // *Actualiza un proyecto en la API y en el array local
  updateProject: async (id, data) => {
    set({ loading: true, error: null })
    try {
      const response = await api.updateProject(id, data)
      set((state) => ({
        projects: state.projects.map((p) => (p.id === id ? response.data : p)),
        loading: false,
      }))
    } catch {
      set({ error: 'Error al actualizar proyecto', loading: false })
    }
  },

  // *Actualiza una URL de imagen en el estado local sin hacer otra llamada a la API
  setImage: (id, field, url) => {
    set((state) => ({
      projects: state.projects.map((p) =>
        p.id === id ? { ...p, [field]: url } : p,
      ),
    }))
  },

  // *Elimina un proyecto de la API y del array local
  deleteProject: async (id) => {
    set({ loading: true, error: null })
    try {
      await api.deleteProject(id)
      set((state) => ({
        projects: state.projects.filter((p) => p.id !== id),
        loading: false,
      }))
    } catch {
      set({ error: 'Error al eliminar proyecto', loading: false })
    }
  },
}))

export default useProjectStore
