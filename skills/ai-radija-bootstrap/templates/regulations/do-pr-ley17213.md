## Regulación aplicable — República Dominicana / Puerto Rico

### República Dominicana — Ley 172-13

**Marco:** Ley 172-13 sobre Protección Integral de los Datos Personales. Autoridad: Superintendencia de Bancos (para datos financieros) y otras según sector.

- **Consentimiento por escrito** para datos personales; verbal grabado válido para fines comerciales.
- **Derechos ARCO**.
- **Datos financieros** tienen régimen especial (Ley 6132 de Buró de Crédito).
- Penalidades de hasta 100 salarios mínimos.

### Puerto Rico — GLBA + HIPAA si aplica

Como territorio de EE.UU., aplica:
- **GLBA (Gramm-Leach-Bliley Act)** para servicios financieros.
- **HIPAA** si se procesan datos de salud.
- **Ley 111-2005** de Puerto Rico sobre notificación de brechas (Information Security and Notification Act).
- Notificación de brecha al consumidor "tan pronto como sea posible" sin demora irrazonable.

### Implementación en el scaffold

- Para DO: tabla `{{AppPrefix}}_ConsentEvidence` con campo `RecordingUrl` para consentimientos por canal telefónico.
- Para PR: middleware de detección de PII para cumplir GLBA Safeguards Rule.
- Cifrado en reposo y en tránsito obligatorio en ambos.
- Endpoint `/api/breach-notification/log` para registrar incidentes notificados.

### Datos cross-border

DO: permitido con consentimiento. PR: regido por leyes federales de EE.UU.; transferencias dentro de jurisdicciones de Privacy Shield/DPF cuando aplique.
