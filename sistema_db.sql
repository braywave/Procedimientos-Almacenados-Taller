-- Ejercicio Procedimientos Almacenados hecho por Bryan David Yepes Ordoñez

-- Creación de las tablas
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion INT -- duración en horas
);

CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion INT,
    nota DECIMAL(5,2),
    fecha_evaluacion DATE,
    FOREIGN KEY (id_inscripcion) REFERENCES Inscripciones(id_inscripcion)
);

-- Inserción de datos (10 registros por tabla)
INSERT INTO Cursos (nombre, descripcion, duracion) VALUES
('SQL Básico', 'Curso introductorio sobre SQL', 10),
('Python para Data Science', 'Aprendizaje de Python enfocado en análisis de datos', 20),
('Fundamentos de Redes', 'Conceptos básicos de redes de computadoras', 15),
('Java Avanzado', 'Curso avanzado de Java', 25),
('Cálculo I', 'Introducción al cálculo diferencial', 40),
('Machine Learning', 'Curso introductorio sobre aprendizaje automático', 30),
('Diseño Web con CSS', 'Aprendizaje de CSS para diseño web', 15),
('Administración de Bases de Datos', 'Curso sobre gestión de bases de datos', 25),
('Estructuras de Datos', 'Curso sobre estructuras de datos en programación', 35),
('Seguridad Informática', 'Fundamentos de ciberseguridad', 20);

INSERT INTO Estudiantes (nombre, correo) VALUES
('Juan Pérez', 'juan.perez@example.com'),
('María López', 'maria.lopez@example.com'),
('Carlos Ramírez', 'carlos.ramirez@example.com'),
('Ana Torres', 'ana.torres@example.com'),
('Luis Fernández', 'luis.fernandez@example.com'),
('Elena Díaz', 'elena.diaz@example.com'),
('Pedro Gómez', 'pedro.gomez@example.com'),
('Marta Ruiz', 'marta.ruiz@example.com'),
('Jorge Herrera', 'jorge.herrera@example.com'),
('Sofía Sánchez', 'sofia.sanchez@example.com');

INSERT INTO Inscripciones (id_estudiante, id_curso, fecha_inscripcion) VALUES
(1, 1, '2025-01-10'),
(2, 2, '2025-01-15'),
(3, 3, '2025-01-20'),
(4, 4, '2025-01-25'),
(5, 5, '2025-02-01'),
(6, 6, '2025-02-05'),
(7, 7, '2025-02-10'),
(8, 8, '2025-02-15'),
(9, 9, '2025-02-20'),
(10, 10, '2025-02-25');

INSERT INTO Calificaciones (id_inscripcion, nota, fecha_evaluacion) VALUES
(1, 85.5, '2025-03-01'),
(2, 90.0, '2025-03-02'),
(3, 75.8, '2025-03-03'),
(4, 88.2, '2025-03-04'),
(5, 92.5, '2025-03-05'),
(6, 80.3, '2025-03-06'),
(7, 85.0, '2025-03-07'),
(8, 78.9, '2025-03-08'),
(9, 88.6, '2025-03-09'),
(10, 91.2, '2025-03-10');

--Procesos almacenados

-- 1. Procedimiento para inscribir un estudiante en un curso
DELIMITER //
CREATE PROCEDURE InscribirEstudiante(
    IN p_id_estudiante INT,
    IN p_id_curso INT,
    IN p_fecha_inscripcion DATE
)
BEGIN
    INSERT INTO Inscripciones (id_estudiante, id_curso, fecha_inscripcion)
    VALUES (p_id_estudiante, p_id_curso, p_fecha_inscripcion);
END //
DELIMITER ;

-- 2. Procedimiento para calcular el promedio de notas de un estudiante
DELIMITER //
CREATE PROCEDURE CalcularPromedioNotas(
    IN p_id_estudiante INT,
    OUT p_promedio DECIMAL(5,2)
)
BEGIN
    SELECT AVG(nota) INTO p_promedio
    FROM Calificaciones c
    JOIN Inscripciones i ON c.id_inscripcion = i.id_inscripcion
    WHERE i.id_estudiante = p_id_estudiante;
END //
DELIMITER ;

-- 3. Procedimiento para obtener la lista de cursos en los que está inscrito un estudiante
DELIMITER //
CREATE PROCEDURE ObtenerCursosEstudiante(
    IN p_id_estudiante INT
)
BEGIN
    SELECT c.id_curso, c.nombre, c.descripcion
    FROM Cursos c
    JOIN Inscripciones i ON c.id_curso = i.id_curso
    WHERE i.id_estudiante = p_id_estudiante;
END //
DELIMITER ;

-- 4. Procedimiento para actualizar la calificación de un estudiante en un curso
DELIMITER //
CREATE PROCEDURE ActualizarCalificacion(
    IN p_id_inscripcion INT,
    IN p_nota DECIMAL(5,2),
    IN p_fecha_evaluacion DATE
)
BEGIN
    UPDATE Calificaciones
    SET nota = p_nota, fecha_evaluacion = p_fecha_evaluacion
    WHERE id_inscripcion = p_id_inscripcion;
END //
DELIMITER ;

-- 5. Procedimiento para eliminar la inscripción de un estudiante en un curso
DELIMITER //
CREATE PROCEDURE EliminarInscripcion(
    IN p_id_inscripcion INT
)
BEGIN
    DELETE FROM Inscripciones
    WHERE id_inscripcion = p_id_inscripcion;
END //
DELIMITER ;