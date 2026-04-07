import cloudinary
from app.core.config import settings
import cloudinary.uploader

# *Configuración de cloudinary
cloudinary.config(
    cloud_name=settings.cloudinary_cloud_name,
    api_key = settings.cloudinary_api_key,
    api_secret = settings.cloudinary_api_secret
)

def upload_image(file_bytes: bytes, folder: str = "hatchway") -> str:
    result = cloudinary.uploader.upload(file_bytes,folder = folder)
    return result["secure_url"]

def delete_image(public_id) -> None:
    cloudinary.uploader.destroy(public_id)