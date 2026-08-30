"""Master Node Router - Orquestador Central de MoviYa

Este es el núcleo inteligente que:
1. Recibe solicitudes de usuarios
2. Clasifica intenciones mediante LLM
3. Delega tareas a agentes especializados
4. Coordina respuestas en tiempo real
"""

import os
from contextlib import asynccontextmanager
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import logging
from typing import Optional
import aiohttp

# Cargar variables de entorno
load_dotenv()

# Configuración de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# ============================================
# INICIALIZACION DE SERVICIOS
# ============================================

class ServiceRegistry:
    """Registro centralizado de microservicios"""
    
    SERVICES = {
        'ecommerce': os.getenv('ECOMMERCE_URL', 'http://localhost:8001'),
        'logistics': os.getenv('LOGISTICS_URL', 'http://localhost:8002'),
        'payments': os.getenv('PAYMENTS_URL', 'http://localhost:8003'),
    }
    
    @staticmethod
    async def health_check():
        """Verificar disponibilidad de servicios"""
        results = {}
        async with aiohttp.ClientSession() as session:
            for service_name, url in ServiceRegistry.SERVICES.items():
                try:
                    async with session.get(f"{url}/health", timeout=aiohttp.ClientTimeout(total=5)) as resp:
                        results[service_name] = {
                            'status': 'up' if resp.status == 200 else 'down',
                            'url': url
                        }
                except Exception as e:
                    results[service_name] = {'status': 'down', 'error': str(e)}
        return results


class MasterNodeRouter:
    """Orquestador Central - Procesa intenciones y delega a agentes"""
    
    def __init__(self):
        self.openai_api_key = os.getenv('OPENAI_API_KEY')
        if not self.openai_api_key:
            raise ValueError("OPENAI_API_KEY no está configurada")
        
        self.intent_classifier_prompt = """
Clasifica la siguiente intención de usuario en una de estas categorías:
- 'ecommerce': Búsqueda de productos o compras
- 'logistics': Consultas sobre envío o transporte
- 'payments': Preguntas sobre pagos o facturación
- 'support': Soporte técnico o problemas
- 'rewards': Consultas sobre puntos o recompensas
- 'general': Otras consultas

Responde SOLO con el nombre de la categoría sin explicaciones adicionales.

Intención: {user_input}
"""
    
    async def classify_intent(self, user_input: str) -> str:
        """Clasifica la intención del usuario usando LLM"""
        try:
            # Placeholder - en producción usar OpenAI API
            # Para desarrollo, usar lógica simple
            if any(word in user_input.lower() for word in ['precio', 'producto', 'buscar', 'comprar']):
                return 'ecommerce'
            elif any(word in user_input.lower() for word in ['envío', 'transporte', 'uber', 'rappi', 'didi']):
                return 'logistics'
            elif any(word in user_input.lower() for word in ['pago', 'factura', 'binance', 'usdt']):
                return 'payments'
            elif any(word in user_input.lower() for word in ['ayuda', 'problema', 'error', 'soporte']):
                return 'support'
            elif any(word in user_input.lower() for word in ['puntos', 'recompensas', 'nivel vip']):
                return 'rewards'
            else:
                return 'general'
        except Exception as e:
            logger.error(f"Error clasificando intención: {e}")
            return 'general'
    
    async def delegate_to_specialist(self, intent: str, params: dict) -> dict:
        """Delega tarea al agente especializado correspondiente"""
        
        delegation_map = {
            'ecommerce': self._delegate_to_ecommerce,
            'logistics': self._delegate_to_logistics,
            'payments': self._delegate_to_payments,
            'support': self._delegate_to_support,
            'rewards': self._delegate_to_rewards,
        }
        
        handler = delegation_map.get(intent, self._delegate_to_general)
        return await handler(params)
    
    async def _delegate_to_ecommerce(self, params: dict) -> dict:
        """Delega búsqueda de productos al Motor E-commerce"""
        try:
            async with aiohttp.ClientSession() as session:
                url = f"{ServiceRegistry.SERVICES['ecommerce']}/api/search"
                async with session.post(url, json=params) as resp:
                    return await resp.json()
        except Exception as e:
            logger.error(f"Error en delegación E-commerce: {e}")
            return {'error': str(e), 'status': 'failed'}
    
    async def _delegate_to_logistics(self, params: dict) -> dict:
        """Delega cotización de envío al Motor Logístico"""
        try:
            async with aiohttp.ClientSession() as session:
                url = f"{ServiceRegistry.SERVICES['logistics']}/api/quote"
                async with session.post(url, json=params) as resp:
                    return await resp.json()
        except Exception as e:
            logger.error(f"Error en delegación Logística: {e}")
            return {'error': str(e), 'status': 'failed'}
    
    async def _delegate_to_payments(self, params: dict) -> dict:
        """Delega procesamiento de pago"""
        return {'status': 'pending', 'message': 'Servicio de pagos en desarrollo'}
    
    async def _delegate_to_support(self, params: dict) -> dict:
        """Delega soporte técnico"""
        return {'status': 'assigned', 'message': 'Ticket de soporte creado'}
    
    async def _delegate_to_rewards(self, params: dict) -> dict:
        """Delega consultas de recompensas"""
        return {'points': 0, 'level': 'Bronze', 'message': 'Sistema de recompensas en desarrollo'}
    
    async def _delegate_to_general(self, params: dict) -> dict:
        """Respuesta por defecto"""
        return {'status': 'success', 'message': 'Consulta procesada'}


# Instancia global del orquestador
master_router = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Gestión del ciclo de vida de la aplicación"""
    # Startup
    global master_router
    master_router = MasterNodeRouter()
    logger.info("🚀 MoviYa Orchestrator iniciado")
    
    # Verificar servicios disponibles
    health = await ServiceRegistry.health_check()
    logger.info(f"Estado de servicios: {health}")
    
    yield
    
    # Shutdown
    logger.info("🛑 MoviYa Orchestrator detenido")


# ============================================
# INICIALIZACION DE FASTAPI
# ============================================

app = FastAPI(
    title="MoviYa Orchestrator",
    description="Master Node Router - Orquestador Central del Ecosistema MoviYa",
    version="2.0.0",
    lifespan=lifespan
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================
# ENDPOINTS
# ============================================

@app.get("/health")
async def health_check():
    """Verifica la salud del orquestador"""
    services = await ServiceRegistry.health_check()
    return {
        'status': 'healthy',
        'service': 'orchestrator',
        'version': '2.0.0',
        'services': services
    }


@app.post("/api/process")
async def process_request(request_data: dict):
    """
    Endpoint principal: Procesa solicitudes de usuario
    """
    try:
        user_input = request_data.get('user_input')
        user_id = request_data.get('user_id')
        
        if not user_input:
            raise HTTPException(status_code=400, detail="user_input es requerido")
        
        intent = await master_router.classify_intent(user_input)
        logger.info(f"Intención clasificada: {intent}")
        
        delegation_params = {
            'query': user_input,
            'user_id': user_id,
        }
        
        result = await master_router.delegate_to_specialist(intent, delegation_params)
        
        return {
            'status': 'success',
            'intent': intent,
            'result': result,
            'user_id': user_id
        }
    
    except Exception as e:
        logger.error(f"Error procesando solicitud: {e}")
        return {'status': 'error', 'message': str(e)}


@app.post("/api/search")
async def search_products(query: str, destination: Optional[str] = None, urgency: Optional[str] = None):
    """
    Búsqueda agregada de productos y logística
    """
    try:
        params = {
            'query': query,
            'destination': destination or 'Colombia',
            'urgency': urgency or 'week'
        }
        
        ecommerce_result = await master_router._delegate_to_ecommerce(params)
        logistics_result = await master_router._delegate_to_logistics(params)
        
        return {
            'status': 'success',
            'ecommerce': ecommerce_result,
            'logistics': logistics_result,
            'query': query
        }
    
    except Exception as e:
        logger.error(f"Error en búsqueda: {e}")
        return {'status': 'error', 'message': str(e)}


@app.post("/api/checkout")
async def checkout(
    items: list,
    payment_method: str = 'usdt',
    user_id: Optional[str] = None
):
    """
    Procesar pago y crear orden
    """
    try:
        total_price = sum(item['price'] * item.get('quantity', 1) for item in items)
        dynamic_fee = total_price * 0.05
        final_price = total_price + dynamic_fee
        
        return {
            'status': 'pending',
            'order_id': 'ORD-' + os.urandom(8).hex().upper(),
            'original_price': total_price,
            'fee': dynamic_fee,
            'final_price': final_price,
            'payment_method': payment_method,
            'message': 'Redirigiendo a pasarela de pago...'
        }
    
    except Exception as e:
        logger.error(f"Error en checkout: {e}")
        return {'status': 'error', 'message': str(e)}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        log_level="info"
    )
