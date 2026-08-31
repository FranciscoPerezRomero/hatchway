import client from './client'
import { Project, ProjectCreate } from '../types/project'

// *Obtener todos (sin filtro = vista admin completa)
export const getProjects = () =>
  client.get<Project[]>('/api/projects')

// *Obtener uno
export const getProject = (id: number) =>
  client.get<Project>(`/api/projects/${id}`)

// *Crear
export const createProject = (data: ProjectCreate) =>
  client.post<Project>('/api/projects', data)

// *Actualizar
export const updateProject = (id: number, data: ProjectCreate) =>
  client.put<Project>(`/api/projects/${id}`, data)

// *Eliminar
export const deleteProject = (id: number) =>
  client.delete(`/api/projects/${id}`)

// *Subir imagen — field "hero" → hero_image_url, "card" → card_thumbnail_url
export const uploadImage = (id: number, file: File, field: 'hero' | 'card' = 'card') => {
  const formData = new FormData()
  formData.append('file', file)
  return client.post<{ url: string; field: string }>(
    `/api/projects/${id}/images?field=${field}`,
    formData,
  )
}
