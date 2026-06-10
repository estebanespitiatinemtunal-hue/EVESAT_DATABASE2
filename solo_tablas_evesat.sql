CREATE TABLE `clientes` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre_completo` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `empresa` varchar(150) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `confirmaciones_evento` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `evento_id` char(36) NOT NULL,
  `cotizacion_id` char(36) NOT NULL,
  `aprobado_por` char(36) DEFAULT NULL,
  `condiciones` text DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `estado` enum('pendiente_firma','firmado','confirmado','cancelado') NOT NULL DEFAULT 'pendiente_firma',
  `fecha_confirmacion` datetime DEFAULT NULL,
  `fecha_aprobacion` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `cotizaciones` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `cliente_id` char(36) NOT NULL,
  `evento_id` char(36) NOT NULL,
  `creado_por` char(36) DEFAULT NULL,
  `presupuesto_max` decimal(14,2) DEFAULT 0.00,
  `subtotal` decimal(14,2) NOT NULL DEFAULT 0.00,
  `descuento` decimal(14,2) NOT NULL DEFAULT 0.00,
  `impuestos` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total_estimado` decimal(14,2) NOT NULL DEFAULT 0.00,
  `notas` text DEFAULT NULL,
  `estado` enum('borrador','enviada','en_revision','aprobada','rechazada','vencida') NOT NULL DEFAULT 'borrador',
  `fecha_vencimiento` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `eventos` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `cliente_id` char(36) NOT NULL,
  `servicio_id` char(36) NOT NULL,
  `paquete_id` char(36) DEFAULT NULL,
  `nombre_evento` varchar(200) NOT NULL,
  `fecha_evento` date NOT NULL,
  `num_invitados` int(11) DEFAULT 0,
  `lugar` varchar(250) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `estado` enum('pendiente','en_cotizacion','cotizado','confirmado','en_curso','finalizado','cancelado') NOT NULL DEFAULT 'pendiente',
  `created_by` char(36) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `inventario` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre` varchar(150) NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_emoji` varchar(20) DEFAULT NULL,
  `cantidad_total` int(11) NOT NULL DEFAULT 1,
  `cantidad_disponible` int(11) NOT NULL DEFAULT 1,
  `estado` enum('disponible','reservado','en_mantenimiento','dado_de_baja') NOT NULL DEFAULT 'disponible',
  `notas` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `items_cotizacion` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `cotizacion_id` char(36) NOT NULL,
  `servicio_id` char(36) DEFAULT NULL,
  `paquete_id` char(36) DEFAULT NULL,
  `descripcion` varchar(300) NOT NULL,
  `precio_unitario` decimal(14,2) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `descuento_item` decimal(14,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(14,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `notificaciones` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `usuario_id` char(36) NOT NULL,
  `tipo` varchar(60) NOT NULL,
  `categoria` enum('general','pendiente','importante','sistema') NOT NULL DEFAULT 'general',
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `leida` tinyint(1) NOT NULL DEFAULT 0,
  `url_accion` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `paquetes` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `servicio_id` char(36) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_base` decimal(14,2) NOT NULL DEFAULT 0.00,
  `capacidad_min` int(11) DEFAULT 0,
  `capacidad_max` int(11) DEFAULT 0,
  `es_popular` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `permisos` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `modulo` varchar(80) NOT NULL,
  `accion` varchar(80) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `reservas_inventario` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `inventario_id` char(36) NOT NULL,
  `evento_id` char(36) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `estado` enum('activa','devuelta','cancelada') NOT NULL DEFAULT 'activa',
  `notas` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roles` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `roles_permisos` (
  `rol_id` char(36) NOT NULL,
  `permiso_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `servicios` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuarios` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre_completo` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `avatar_iniciales` varchar(5) DEFAULT NULL,
  `estado` enum('activo','inactivo','suspendido') NOT NULL DEFAULT 'activo',
  `ultimo_acceso` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuarios_roles` (
  `usuario_id` char(36) NOT NULL,
  `rol_id` char(36) NOT NULL,
  `asignado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;