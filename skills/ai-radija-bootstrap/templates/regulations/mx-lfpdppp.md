## Regulación aplicable — México

**Marco:** Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP) + lineamientos del INAI.

### Obligaciones que el proyecto debe cumplir

- **Aviso de Privacidad** visible y accesible en todo punto donde se capten datos personales.
- **Consentimiento expreso** para datos sensibles (salud, ideología, datos financieros, biométricos).
- **Derechos ARCO** (Acceso, Rectificación, Cancelación, Oposición) — implementar endpoint o canal documentado.
- **Encargado de datos** designado por escrito si se subcontrata tratamiento.
- **Medidas de seguridad** administrativas, físicas y técnicas proporcionales al riesgo.
- **Vulneraciones** deben notificarse al titular afectado "sin dilación" (recomendado: < 72h).
- **Retención limitada**: definir periodo de conservación por tipo de dato; eliminar (lógicamente) al vencer.

### Implementación en el scaffold

- Tabla `{{AppPrefix}}_PrivacyConsents` con `UserId`, `ConsentType`, `GrantedAt`, `RevokedAt`, `IpAddress`.
- Endpoint `/api/arco/{request-type}` para gestionar solicitudes ARCO.
- Política de retención por entidad documentada en `database/retention-policy.md`.
- Logging de accesos a datos sensibles en `{{AppPrefix}}_DataAccessLog`.

### Datos cross-border

México permite transferencias internacionales bajo condiciones (consentimiento o cláusulas contractuales). Documentar en el aviso de privacidad cualquier transferencia a EE.UU. o región Azure fuera de MX.
