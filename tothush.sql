-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-05-2024 a las 04:21:05
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

drop database tothush;
CREATE DATABASE IF NOT EXISTS tothush;
use tothush;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tothush`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CopyDatabase` ()   BEGIN
    DECLARE src_db VARCHAR(64) DEFAULT 'tothush';
    DECLARE dest_db VARCHAR(64);
    DECLARE tbl_name VARCHAR(64);
    DECLARE done INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT table_name FROM information_schema.tables
        WHERE table_schema = src_db;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Generar nombre de la base de datos de destino
    SET dest_db = CONCAT(src_db, '_backup_', DATE_FORMAT(NOW(), '%Y%m%d%H%i'));

    -- Crear la base de datos de destino
    SET @create_db = CONCAT('CREATE DATABASE ', dest_db);
    PREPARE stmt FROM @create_db;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Abrir cursor para iterar sobre las tablas
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tbl_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Copiar cada tabla a la base de datos de destino
        SET @copy_table = CONCAT('CREATE TABLE ', dest_db, '.', tbl_name, ' LIKE ', src_db, '.', tbl_name);
        PREPARE stmt FROM @copy_table;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @insert_data = CONCAT('INSERT INTO ', dest_db, '.', tbl_name, ' SELECT * FROM ', src_db, '.', tbl_name);
        PREPARE stmt FROM @insert_data;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBackupEventStatus` ()   BEGIN
    SELECT 
        EVENT_NAME,
        IFNULL(LAST_EXECUTED, NOW()) AS LAST_EXECUTED,
        INTERVAL_VALUE,
        INTERVAL_FIELD,
        ADDTIME(IFNULL(LAST_EXECUTED, NOW()), CONCAT(INTERVAL_VALUE, ' ', INTERVAL_FIELD)) AS NEXT_EXECUTION,
        TIMESTAMPDIFF(SECOND, NOW(), ADDTIME(IFNULL(LAST_EXECUTED, NOW()), CONCAT(INTERVAL_VALUE, ' ', INTERVAL_FIELD))) AS SECONDS_UNTIL_NEXT_EXECUTION
    FROM 
        information_schema.EVENTS
    WHERE 
        EVENT_NAME = 'backup_event';
END$$

DELIMITER ;


--
-- Estructura de tabla para la tabla `Category`
--

CREATE TABLE `Category` (
  `CategoryID` int(11) NOT NULL,
  `CategoryName` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Category`
--

INSERT INTO `Category` (`CategoryID`, `CategoryName`, `Description`) VALUES
(1, 'Bebidas', 'Todo tipo de bebidas'),
(2, 'Snacks', 'Aperitivos y bocadillos'),
(3, 'Lácteos', 'Productos lácteos'),
(4, 'Carnes', 'Carnes frescas y embutidos'),
(5, 'Frutas y Verduras', 'Frutas y verduras frescas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Customer`
--

CREATE TABLE `Customer` (
  `CustomerID` int(11) NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Customer`
--

INSERT INTO `Customer` (`CustomerID`, `FirstName`, `LastName`, `Email`, `Phone`, `Address`) VALUES
(1, 'Andrés', 'Torres', 'andres.torres@example.com', '555111222', 'Calle Primavera 12'),
(2, 'Claudia', 'Ruiz', 'claudia.ruiz@example.com', '555333444', 'Avenida del Sol 34'),
(3, 'Fernando', 'Morales', 'fernando.morales@example.com', '555555666', 'Calle Luna 56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `User`
--

CREATE TABLE `User` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(255) NOT NULL,
  `UserPassword` varchar(255) NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `HireDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `User`
--

INSERT INTO `User` (`UserID`, `UserName`, `UserPassword`, `FirstName`, `LastName`, `Email`, `Phone`, `HireDate`) VALUES
(1, 'lcastro', 'password123', 'Lucía', 'Castro', 'lucia.castro@example.com', '555777888', '2020-06-15'),
(2, 'rgomez', 'password456', 'Roberto', 'Gómez', 'roberto.gomez@example.com', '555999000', '2019-05-22'),
(3, 'iperez', 'password789', 'Isabel', 'Pérez', 'isabel.perez@example.com', '555222333', '2018-09-10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Rol`
--

CREATE TABLE `Role` (
  `RoleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Role` varchar(255) NOT NULL,
  `AsignDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Rol`
--

INSERT INTO `Role` (`RoleID`, `UserID`, `Role`, `AsignDate`) VALUES
(1, 1, 'Cajera', '2020-06-15'),
(2, 2, 'Cajero', '2019-05-22'),
(3, 3, 'Supervisor', '2018-09-10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Product`
--

CREATE TABLE `Product` (
  `ProductID` int(11) NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  `Stock` int(11) NOT NULL,
  `CategoryID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Product`
--

INSERT INTO `Product` (`ProductID`, `ProductName`, `Description`, `UnitPrice`, `Stock`, `CategoryID`) VALUES
(1, 'Agua Mineral 1L', 'Agua mineral sin gas 1 litro', 1.00, 150, 1),
(2, 'Té Lipton 1L', 'Té frío 1 litro', 1.30, 90, 1),
(3, 'Chocolatina', 'Barra de chocolate 50g', 0.80, 120, 2),
(4, 'Leche Entera', 'Leche entera 1 litro', 2.10, 70, 3),
(5, 'Queso Parmesano', 'Queso parmesano 200g', 4.00, 25, 3),
(6, 'Chuletas de Cerdo', 'Chuletas de cerdo 1kg', 6.50, 15, 4),
(7, 'Peras', 'Peras frescas 1kg', 2.60, 30, 5),
(8, 'Zanahorias', 'Zanahorias frescas 1kg', 1.90, 35, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Saledetail`
--

CREATE TABLE `Saledetail` (
  `SaleDetailID` int(11) NOT NULL,
  `SaleID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Saledetail`
--

INSERT INTO `Saledetail` (`SaleDetailID`, `SaleID`, `ProductID`, `Quantity`, `UnitPrice`, `Subtotal`) VALUES
(1, 1, 1, 2, 1.00, 2.00),
(2, 1, 3, 2, 0.80, 1.60),
(3, 1, 8, 1, 1.90, 1.90),
(4, 2, 2, 1, 1.30, 1.30),
(5, 2, 4, 2, 2.10, 4.20),
(6, 2, 7, 1, 2.60, 2.60),
(7, 3, 5, 1, 4.00, 4.00),
(8, 3, 6, 1, 6.50, 6.50),
(9, 3, 8, 2, 1.90, 3.80);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Sale`
--

CREATE TABLE `Sale` (
  `SaleID` int(11) NOT NULL,
  `SaleDate` datetime NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `UserID` int(11) NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `Sale`
--

INSERT INTO `Sale` (`SaleID`, `SaleDate`, `CustomerID`, `UserID`, `TotalAmount`) VALUES
(1, '2024-05-23 11:00:00', 1, 1, 4.60),
(2, '2024-05-24 15:20:00', 2, 2, 7.10),
(3, '2024-05-25 10:35:00', 3, 1, 8.90);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indices de la tabla `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`CustomerID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indices de la tabla `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Email` (`Email`);

--

-- Indices de la tabla `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`ProductID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- Indices de la tabla `Saledetail`
--
ALTER TABLE `Saledetail`
  ADD PRIMARY KEY (`SaleDetailID`),
  ADD KEY `SaleID` (`SaleID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indices de la tabla `Sale`
--
ALTER TABLE `Sale`
  ADD PRIMARY KEY (`SaleID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `UserID` (`UserID`);

-- Indices de la tabla `Rol`
--
ALTER TABLE `Role`
  ADD PRIMARY KEY (`RoleID`),
  ADD KEY `UserID` (`UserID`);
--

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Category`
--
ALTER TABLE `Category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `Customer`
--
ALTER TABLE `Customer`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `User`
--
ALTER TABLE `User`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `Product`
--
ALTER TABLE `Product`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `Saledetail`
--
ALTER TABLE `Saledetail`
  MODIFY `SaleDetailID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `Sale`
--
ALTER TABLE `Sale`
  MODIFY `SaleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `Rol`
--
ALTER TABLE `Role`
  MODIFY `RoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `Category` (`CategoryID`);

--
-- Filtros para la tabla `Saledetail`
--
ALTER TABLE `Saledetail`
  ADD CONSTRAINT `saledetail_ibfk_1` FOREIGN KEY (`SaleID`) REFERENCES `Sale` (`SaleID`),
  ADD CONSTRAINT `saledetail_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Product` (`ProductID`);

--
-- Filtros para la tabla `Sale`
--
ALTER TABLE `Sale`
  ADD CONSTRAINT `sale_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `Customer` (`CustomerID`),
  ADD CONSTRAINT `sale_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);
  
-- Filtros para la tabla `Rol`
--
ALTER TABLE `Role`
  ADD CONSTRAINT `role_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- Create the log table to store database activity
CREATE TABLE ActivityLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OperationType VARCHAR(10),
    TableName VARCHAR(255),
    OperationTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserName VARCHAR(255)
);

-- Create a trigger to log INSERT operations
DELIMITER $$
CREATE TRIGGER LogInsert AFTER INSERT ON `Category`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Category', USER());
END$$

CREATE TRIGGER LogInsertCustomer AFTER INSERT ON `Customer`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Customer', USER());
END$$

CREATE TRIGGER LogInsertUser AFTER INSERT ON `User`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'User', USER());
END$$

CREATE TRIGGER LogInsertRole AFTER INSERT ON `Role`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Role', USER());
END$$

CREATE TRIGGER LogInsertProduct AFTER INSERT ON `Product`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Product', USER());
END$$

CREATE TRIGGER LogInsertSaledetail AFTER INSERT ON `Saledetail`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Saledetail', USER());
END$$

CREATE TRIGGER LogInsertSale AFTER INSERT ON `Sale`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('INSERT', 'Sale', USER());
END$$

-- Create triggers for UPDATE operations
CREATE TRIGGER LogUpdate AFTER UPDATE ON `Category`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Category', USER());
END$$

CREATE TRIGGER LogUpdateCustomer AFTER UPDATE ON `Customer`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Customer', USER());
END$$

CREATE TRIGGER LogUpdateUser AFTER UPDATE ON `User`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'User', USER());
END$$

CREATE TRIGGER LogUpdateRole AFTER UPDATE ON `Role`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Role', USER());
END$$

CREATE TRIGGER LogUpdateProduct AFTER UPDATE ON `Product`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Product', USER());
END$$

CREATE TRIGGER LogUpdateSaledetail AFTER UPDATE ON `Saledetail`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Saledetail', USER());
END$$

CREATE TRIGGER LogUpdateSale AFTER UPDATE ON `Sale`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('UPDATE', 'Sale', USER());
END$$

-- Create triggers for DELETE operations
CREATE TRIGGER LogDelete AFTER DELETE ON `Category`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Category', USER());
END$$

CREATE TRIGGER LogDeleteCustomer AFTER DELETE ON `Customer`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Customer', USER());
END$$

CREATE TRIGGER LogDeleteUser AFTER DELETE ON `User`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'User', USER());
END$$

CREATE TRIGGER LogDeleteRole AFTER DELETE ON `Role`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Role', USER());
END$$

CREATE TRIGGER LogDeleteProduct AFTER DELETE ON `Product`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Product', USER());
END$$

CREATE TRIGGER LogDeleteSaledetail AFTER DELETE ON `Saledetail`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Saledetail', USER());
END$$

CREATE TRIGGER LogDeleteSale AFTER DELETE ON `Sale`
FOR EACH ROW
BEGIN
    INSERT INTO ActivityLog (OperationType, TableName, UserName)
    VALUES ('DELETE', 'Sale', USER());
END$$
DELIMITER ;
