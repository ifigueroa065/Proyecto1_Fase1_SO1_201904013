CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    cpu_total BIGINT NOT NULL,
    cpu_uso BIGINT NOT NULL,
    cpu_libre BIGINT NOT NULL,
    cpu_porcentaje INT NOT NULL,
    ram_total BIGINT NOT NULL,
    ram_uso BIGINT NOT NULL,
    ram_libre BIGINT NOT NULL,
    ram_porcentaje INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
