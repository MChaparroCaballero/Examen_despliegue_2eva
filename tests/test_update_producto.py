import sys
from pathlib import Path

# Agregar la raíz del proyecto al path para los imports
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from app.database import update_producto

if __name__ == "__main__":
    try:
        resultado = update_producto(
            producto_id=1,
            nombre='Martillo 16oz reforzado',
            descripcion='Martillo de acero reforzado con mango antideslizante',
            precio=14.90,
            stock=50,
            categoria='Herramientas',
            codigo_sku='MART-16OZ5',
            activo=True
        )

        if resultado:
            print('✅ Producto actualizado correctamente')
        else:
            print('⚠️ Producto no encontrado')
    except Exception as e:
        print('❌ Error al actualizar producto →', e)

# ===== EJECUCIÓN DESDE CMD =====
# python tests/test_update_producto.py
