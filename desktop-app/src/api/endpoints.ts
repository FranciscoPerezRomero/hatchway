import client from './client'
import { Project, ProjectCreate } from '../types/project'
// Obtener todos
export const getProjects = () =>
  client.get<Project[]>('/api/projects')

// Obtener uno
export const getProject = (id: number) =>
  client.get<Project>(`/api/projects/${id}`)

// Crear
export const createProject = (data: ProjectCreate) =>
  client.post<Project>('/api/projects', data)

// Actualizar
export const updateProject = (id: number, data: ProjectCreate) =>
  client.put<Project>(`/api/projects/${id}`, data)

// Eliminar
export const deleteProject = (id: number) =>
  client.delete(`/api/projects/${id}`)

// Subir imagen
export const uploadImage = (id: number, file: File) => {
  const formData = new FormData()
  formData.append('file', file)
  return client.post<{ thumbnail_url: string }>(
    `/api/projects/${id}/images`,
    formData
  )
}
