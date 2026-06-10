-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-06-2026 a las 03:07:30
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `evesat_database`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `confirmaciones_evento`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizaciones`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

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

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id`, `nombre`, `tipo`, `descripcion`, `imagen_emoji`, `cantidad_total`, `cantidad_disponible`, `estado`, `notas`, `created_at`, `updated_at`) VALUES
('77b7a435-5ee6-11f1-9936-1cd1d7da823b', 'Sistema de audio principal', 'audio', 'Parlantes y mezcladora para eventos', '🔊', 3, 2, 'disponible', NULL, '2026-06-02 19:52:16', '2026-06-02 19:52:16'),
('77b7a769-5ee6-11f1-9936-1cd1d7da823b', 'Sillas tipo Tiffany', 'mobiliario', 'Sillas elegantes para eventos sociales', '🪑', 100, 80, 'disponible', NULL, '2026-06-02 19:52:16', '2026-06-02 19:52:16'),
('77b7a90a-5ee6-11f1-9936-1cd1d7da823b', 'Kit de iluminación LED', 'iluminacion', 'Focos y reflectores RGB para escenarios', '💡', 5, 3, 'disponible', NULL, '2026-06-02 19:52:16', '2026-06-02 19:52:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items_cotizacion`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paquetes`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `modulo` varchar(80) NOT NULL,
  `accion` varchar(80) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `modulo`, `accion`, `descripcion`) VALUES
('77b182d8-5ee6-11f1-9936-1cd1d7da823b', 'usuarios', 'ver', 'Ver lista de usuarios'),
('77b184da-5ee6-11f1-9936-1cd1d7da823b', 'usuarios', 'crear', 'Crear nuevos usuarios'),
('77b185b8-5ee6-11f1-9936-1cd1d7da823b', 'usuarios', 'editar', 'Editar usuarios existentes'),
('77b18649-5ee6-11f1-9936-1cd1d7da823b', 'usuarios', 'eliminar', 'Eliminar usuarios'),
('77b186b2-5ee6-11f1-9936-1cd1d7da823b', 'catalogo', 'ver', 'Ver catálogo de servicios'),
('77b1872d-5ee6-11f1-9936-1cd1d7da823b', 'catalogo', 'crear', 'Crear servicios y paquetes'),
('77b1878d-5ee6-11f1-9936-1cd1d7da823b', 'catalogo', 'editar', 'Editar servicios y paquetes'),
('77b187df-5ee6-11f1-9936-1cd1d7da823b', 'cotizaciones', 'ver', 'Ver cotizaciones'),
('77b18837-5ee6-11f1-9936-1cd1d7da823b', 'cotizaciones', 'crear', 'Crear cotizaciones'),
('77b18874-5ee6-11f1-9936-1cd1d7da823b', 'cotizaciones', 'aprobar', 'Aprobar o rechazar cotizaciones'),
('77b188c1-5ee6-11f1-9936-1cd1d7da823b', 'eventos', 'ver', 'Ver eventos'),
('77b18901-5ee6-11f1-9936-1cd1d7da823b', 'eventos', 'crear', 'Crear eventos'),
('77b18938-5ee6-11f1-9936-1cd1d7da823b', 'eventos', 'confirmar', 'Confirmar eventos'),
('77b18971-5ee6-11f1-9936-1cd1d7da823b', 'inventario', 'ver', 'Ver inventario'),
('77b189a9-5ee6-11f1-9936-1cd1d7da823b', 'inventario', 'gestionar', 'Gestionar equipos e inventario'),
('77b189e8-5ee6-11f1-9936-1cd1d7da823b', 'reportes', 'ver', 'Ver análisis y reportes'),
('77b18a23-5ee6-11f1-9936-1cd1d7da823b', 'notificaciones', 'ver', 'Ver notificaciones propias');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_inventario`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` char(36) NOT NULL DEFAULT uuid(),
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `created_at`) VALUES
('77abe13d-5ee6-11f1-9936-1cd1d7da823b', 'Administrador', 'Acceso total al sistema', '2026-06-02 19:52:16'),
('77abe427-5ee6-11f1-9936-1cd1d7da823b', 'Coordinador', 'Gestión de eventos y cotizaciones', '2026-06-02 19:52:16'),
('77abe5e5-5ee6-11f1-9936-1cd1d7da823b', 'Editor', 'Edición de catálogo e inventario', '2026-06-02 19:52:16'),
('77abe6f8-5ee6-11f1-9936-1cd1d7da823b', 'Usuario', 'Consulta y solicitudes', '2026-06-02 19:52:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `rol_id` char(36) NOT NULL,
  `permiso_id` char(36) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

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

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `categoria`, `imagen_url`, `icono`, `activo`, `created_at`, `updated_at`) VALUES
('77b47c26-5ee6-11f1-9936-1cd1d7da823b', 'Baby Shower', 'Celebraciones llenas de ternura', 'Celebraciones', NULL, 'corazon', 1, '2026-06-02 19:52:16', '2026-06-02 19:52:16'),
('77b47f37-5ee6-11f1-9936-1cd1d7da823b', 'Revelación de Género', 'Momentos de emoción y sorpresa para la familia', 'Celebraciones', NULL, 'estrella', 1, '2026-06-02 19:52:16', '2026-06-02 19:52:16'),
('77b48019-5ee6-11f1-9936-1cd1d7da823b', 'Matrimonio', 'Experiencias memorables para el día más especial', 'Bodas', NULL, 'diamante', 1, '2026-06-02 19:52:16', '2026-06-02 19:52:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_roles`
--

CREATE TABLE `usuarios_roles` (
  `usuario_id` char(36) NOT NULL,
  `rol_id` char(36) NOT NULL,
  `asignado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_actividad_usuarios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_actividad_usuarios` (
`id` char(36)
,`nombre_completo` varchar(150)
,`correo` varchar(150)
,`estado` enum('activo','inactivo','suspendido')
,`ultimo_acceso` datetime
,`roles` mediumtext
,`cotizaciones_creadas` bigint(21)
,`notificaciones_sin_leer` decimal(22,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_conversion_cotizaciones`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_conversion_cotizaciones` (
`total_cotizaciones` bigint(21)
,`aprobadas` decimal(22,0)
,`rechazadas` decimal(22,0)
,`confirmadas` bigint(21)
,`tasa_aprobacion_pct` decimal(27,1)
,`tasa_confirmacion_pct` decimal(25,1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_estado_inventario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_estado_inventario` (
`nombre` varchar(150)
,`tipo` varchar(100)
,`cantidad_total` int(11)
,`cantidad_disponible` int(11)
,`cantidad_reservada` bigint(12)
,`porcentaje_uso` decimal(16,1)
,`estado` enum('disponible','reservado','en_mantenimiento','dado_de_baja')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_eventos_por_servicio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_eventos_por_servicio` (
`servicio` varchar(150)
,`categoria` varchar(100)
,`total_eventos` bigint(21)
,`promedio_invitados` decimal(11,0)
,`confirmados` decimal(22,0)
,`cancelados` decimal(22,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_ingresos_mensuales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_ingresos_mensuales` (
`mes` varchar(7)
,`total_cotizaciones` bigint(21)
,`ingresos_estimados` decimal(36,2)
,`ingresos_confirmados` decimal(36,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `v_actividad_usuarios`
--
DROP TABLE IF EXISTS `v_actividad_usuarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_actividad_usuarios`  AS SELECT `u`.`id` AS `id`, `u`.`nombre_completo` AS `nombre_completo`, `u`.`correo` AS `correo`, `u`.`estado` AS `estado`, `u`.`ultimo_acceso` AS `ultimo_acceso`, group_concat(distinct `r`.`nombre` order by `r`.`nombre` ASC separator ', ') AS `roles`, count(distinct `c`.`id`) AS `cotizaciones_creadas`, sum(case when `n`.`leida` = 0 then 1 else 0 end) AS `notificaciones_sin_leer` FROM ((((`usuarios` `u` left join `usuarios_roles` `ur` on(`ur`.`usuario_id` = `u`.`id`)) left join `roles` `r` on(`r`.`id` = `ur`.`rol_id`)) left join `cotizaciones` `c` on(`c`.`creado_por` = `u`.`id`)) left join `notificaciones` `n` on(`n`.`usuario_id` = `u`.`id`)) GROUP BY `u`.`id`, `u`.`nombre_completo`, `u`.`correo`, `u`.`estado`, `u`.`ultimo_acceso` ORDER BY `u`.`ultimo_acceso` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_conversion_cotizaciones`
--
DROP TABLE IF EXISTS `v_conversion_cotizaciones`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_conversion_cotizaciones`  AS SELECT count(`c`.`id`) AS `total_cotizaciones`, sum(case when `c`.`estado` = 'aprobada' then 1 else 0 end) AS `aprobadas`, sum(case when `c`.`estado` = 'rechazada' then 1 else 0 end) AS `rechazadas`, count(`ce`.`id`) AS `confirmadas`, round(sum(case when `c`.`estado` = 'aprobada' then 1 else 0 end) / nullif(count(`c`.`id`),0) * 100,1) AS `tasa_aprobacion_pct`, round(count(`ce`.`id`) / nullif(count(`c`.`id`),0) * 100,1) AS `tasa_confirmacion_pct` FROM (`cotizaciones` `c` left join `confirmaciones_evento` `ce` on(`ce`.`cotizacion_id` = `c`.`id`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_estado_inventario`
--
DROP TABLE IF EXISTS `v_estado_inventario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_estado_inventario`  AS SELECT `i`.`nombre` AS `nombre`, `i`.`tipo` AS `tipo`, `i`.`cantidad_total` AS `cantidad_total`, `i`.`cantidad_disponible` AS `cantidad_disponible`, `i`.`cantidad_total`- `i`.`cantidad_disponible` AS `cantidad_reservada`, round((`i`.`cantidad_total` - `i`.`cantidad_disponible`) / nullif(`i`.`cantidad_total`,0) * 100,1) AS `porcentaje_uso`, `i`.`estado` AS `estado` FROM `inventario` AS `i` ORDER BY round((`i`.`cantidad_total` - `i`.`cantidad_disponible`) / nullif(`i`.`cantidad_total`,0) * 100,1) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_eventos_por_servicio`
--
DROP TABLE IF EXISTS `v_eventos_por_servicio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_eventos_por_servicio`  AS SELECT `s`.`nombre` AS `servicio`, `s`.`categoria` AS `categoria`, count(`e`.`id`) AS `total_eventos`, round(avg(`e`.`num_invitados`),0) AS `promedio_invitados`, sum(case when `e`.`estado` = 'confirmado' then 1 else 0 end) AS `confirmados`, sum(case when `e`.`estado` = 'cancelado' then 1 else 0 end) AS `cancelados` FROM (`servicios` `s` left join `eventos` `e` on(`e`.`servicio_id` = `s`.`id`)) GROUP BY `s`.`id`, `s`.`nombre`, `s`.`categoria` ORDER BY count(`e`.`id`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_ingresos_mensuales`
--
DROP TABLE IF EXISTS `v_ingresos_mensuales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_ingresos_mensuales`  AS SELECT date_format(`c`.`created_at`,'%Y-%m') AS `mes`, count(`c`.`id`) AS `total_cotizaciones`, sum(`c`.`total_estimado`) AS `ingresos_estimados`, sum(case when `c`.`estado` = 'aprobada' then `c`.`total_estimado` else 0 end) AS `ingresos_confirmados` FROM `cotizaciones` AS `c` GROUP BY date_format(`c`.`created_at`,'%Y-%m') ORDER BY date_format(`c`.`created_at`,'%Y-%m') DESC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `confirmaciones_evento`
--
ALTER TABLE `confirmaciones_evento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `evento_id` (`evento_id`),
  ADD KEY `fk_conf_cotizacion` (`cotizacion_id`),
  ADD KEY `fk_conf_usuario` (`aprobado_por`);

--
-- Indices de la tabla `cotizaciones`
--
ALTER TABLE `cotizaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cot_usuario` (`creado_por`),
  ADD KEY `idx_cotizaciones_cliente` (`cliente_id`),
  ADD KEY `idx_cotizaciones_evento` (`evento_id`),
  ADD KEY `idx_cotizaciones_estado` (`estado`),
  ADD KEY `idx_cotizaciones_fecha` (`created_at`);

--
-- Indices de la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ev_servicio` (`servicio_id`),
  ADD KEY `fk_ev_paquete` (`paquete_id`),
  ADD KEY `fk_ev_creador` (`created_by`),
  ADD KEY `idx_eventos_cliente` (`cliente_id`),
  ADD KEY `idx_eventos_fecha` (`fecha_evento`),
  ADD KEY `idx_eventos_estado` (`estado`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inventario_tipo` (`tipo`),
  ADD KEY `idx_inventario_estado` (`estado`);

--
-- Indices de la tabla `items_cotizacion`
--
ALTER TABLE `items_cotizacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_item_cotizacion` (`cotizacion_id`),
  ADD KEY `fk_item_servicio` (`servicio_id`),
  ADD KEY `fk_item_paquete` (`paquete_id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notif_usuario` (`usuario_id`),
  ADD KEY `idx_notif_leida` (`usuario_id`,`leida`),
  ADD KEY `idx_notif_categoria` (`categoria`);

--
-- Indices de la tabla `paquetes`
--
ALTER TABLE `paquetes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_paq_servicio` (`servicio_id`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_modulo_accion` (`modulo`,`accion`);

--
-- Indices de la tabla `reservas_inventario`
--
ALTER TABLE `reservas_inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_res_inventario` (`inventario_id`),
  ADD KEY `idx_reservas_evento` (`evento_id`),
  ADD KEY `idx_reservas_fechas` (`fecha_inicio`,`fecha_fin`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD PRIMARY KEY (`rol_id`,`permiso_id`),
  ADD KEY `fk_rp_permiso` (`permiso_id`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `idx_usuarios_estado` (`estado`);

--
-- Indices de la tabla `usuarios_roles`
--
ALTER TABLE `usuarios_roles`
  ADD PRIMARY KEY (`usuario_id`,`rol_id`),
  ADD KEY `fk_ur_rol` (`rol_id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `confirmaciones_evento`
--
ALTER TABLE `confirmaciones_evento`
  ADD CONSTRAINT `fk_conf_cotizacion` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`),
  ADD CONSTRAINT `fk_conf_evento` FOREIGN KEY (`evento_id`) REFERENCES `eventos` (`id`),
  ADD CONSTRAINT `fk_conf_usuario` FOREIGN KEY (`aprobado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `cotizaciones`
--
ALTER TABLE `cotizaciones`
  ADD CONSTRAINT `fk_cot_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `fk_cot_evento` FOREIGN KEY (`evento_id`) REFERENCES `eventos` (`id`),
  ADD CONSTRAINT `fk_cot_usuario` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD CONSTRAINT `fk_ev_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `fk_ev_creador` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_ev_paquete` FOREIGN KEY (`paquete_id`) REFERENCES `paquetes` (`id`),
  ADD CONSTRAINT `fk_ev_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`);

--
-- Filtros para la tabla `items_cotizacion`
--
ALTER TABLE `items_cotizacion`
  ADD CONSTRAINT `fk_item_cotizacion` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_item_paquete` FOREIGN KEY (`paquete_id`) REFERENCES `paquetes` (`id`),
  ADD CONSTRAINT `fk_item_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `fk_notif_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `paquetes`
--
ALTER TABLE `paquetes`
  ADD CONSTRAINT `fk_paq_servicio` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reservas_inventario`
--
ALTER TABLE `reservas_inventario`
  ADD CONSTRAINT `fk_res_evento` FOREIGN KEY (`evento_id`) REFERENCES `eventos` (`id`),
  ADD CONSTRAINT `fk_res_inventario` FOREIGN KEY (`inventario_id`) REFERENCES `inventario` (`id`);

--
-- Filtros para la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD CONSTRAINT `fk_rp_permiso` FOREIGN KEY (`permiso_id`) REFERENCES `permisos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rp_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios_roles`
--
ALTER TABLE `usuarios_roles`
  ADD CONSTRAINT `fk_ur_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ur_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
