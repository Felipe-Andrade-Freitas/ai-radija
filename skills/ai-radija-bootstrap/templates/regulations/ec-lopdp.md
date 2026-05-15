## Regulación aplicable — Ecuador

**Marco:** Ley Orgánica de Protección de Datos Personales (LOPDP, 2021). Autoridad: Superintendencia de Protección de Datos Personales.

### Obligaciones que el proyecto debe cumplir

- **Consentimiento libre, específico, informado e inequívoco**.
- **DPO** obligatorio para entidades públicas, tratamientos a gran escala, o datos sensibles.
- **Evaluación de impacto** (DPIA) para tratamientos de alto riesgo.
- **Notificación de brechas** en máximo **5 días** a la Superintendencia y a los titulares afectados.
- **Derechos ARCOP** (Acceso, Rectificación, Cancelación, Oposición, Portabilidad) + derecho a no ser objeto de decisiones automatizadas.
- **Sanciones** del 0.7% al 1% de la facturación del año anterior.

### Implementación en el scaffold

- Webhook al DPO ante eventos críticos detectados en observabilidad.
- Tabla `{{AppPrefix}}_AutomatedDecisions` registrando decisiones automáticas y permitiendo opt-out.
- Plantilla DPIA en `docs/dpia/template.md`.
- Endpoint `/api/data-rights/portability` con export JSON.

### Datos cross-border

Permitidas con consentimiento, base contractual, interés legítimo documentado, o decisión de adecuación de la Superintendencia.
