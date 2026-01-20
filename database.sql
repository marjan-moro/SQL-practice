-- ENGINEERS
CREATE TABLE engineers (
    engineer_id SERIAL PRIMARY KEY,
    name TEXT,
    specialization TEXT,
    years_experience INT
);

-- PROJECTS
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name TEXT,
    start_date DATE,
    lead_engineer INT REFERENCES engineers(engineer_id)
);

-- MATERIALS
CREATE TABLE materials (
    material_id SERIAL PRIMARY KEY,
    name TEXT,
    density_kg_m3 REAL,
    youngs_modulus_gpa REAL,
    yield_strength_mpa REAL
);

-- COMPONENTS
CREATE TABLE components (
    component_id SERIAL PRIMARY KEY,
    name TEXT,
    material_id INT REFERENCES materials(material_id),
    mass_kg REAL,
    cost_usd REAL
);

-- ASSEMBLIES
CREATE TABLE assemblies (
    assembly_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    name TEXT
);

-- ASSEMBLY ↔ COMPONENTS (many-to-many)
CREATE TABLE assembly_components (
    assembly_id INT REFERENCES assemblies(assembly_id),
    component_id INT REFERENCES components(component_id),
    quantity INT,
    PRIMARY KEY (assembly_id, component_id)
);

-- SENSORS
CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    type TEXT,
    accuracy REAL
);

-- TESTS
CREATE TABLE tests (
    test_id SERIAL PRIMARY KEY,
    component_id INT REFERENCES components(component_id),
    sensor_id INT REFERENCES sensors(sensor_id),
    test_type TEXT,
    test_date DATE
);

-- TEST RESULTS
CREATE TABLE test_results (
    result_id SERIAL PRIMARY KEY,
    test_id INT REFERENCES tests(test_id),
    measured_value REAL,
    unit TEXT
);

-- SIMULATIONS
CREATE TABLE simulations (
    simulation_id SERIAL PRIMARY KEY,
    component_id INT REFERENCES components(component_id),
    simulation_type TEXT,
    mesh_size INT
);

-- SIMULATION RESULTS
CREATE TABLE simulation_results (
    sim_result_id SERIAL PRIMARY KEY,
    simulation_id INT REFERENCES simulations(simulation_id),
    max_stress_mpa REAL,
    max_displacement_mm REAL
);


INSERT INTO engineers (name, specialization, years_experience)
SELECT
    'Engineer_' || i,
    (ARRAY['FEA','Thermal','Materials','Dynamics','Manufacturing'])[1 + (random()*4)::int],
    (random()*30)::int
FROM generate_series(1,50) i;


INSERT INTO materials (name, density_kg_m3, youngs_modulus_gpa, yield_strength_mpa)
SELECT
    'Material_' || i,
    2500 + random()*5000,
    50 + random()*200,
    200 + random()*800
FROM generate_series(1,20) i;

INSERT INTO projects (name, start_date, lead_engineer)
SELECT
    'Project_' || i,
    CURRENT_DATE - (random()*1000)::int,
    (random()*49 + 1)::int
FROM generate_series(1,20) i;

INSERT INTO components (name, material_id, mass_kg, cost_usd)
SELECT
    'Component_' || i,
    (random()*19 + 1)::int,
    random()*50 + 1,
    random()*500 + 50
FROM generate_series(1,300) i;


INSERT INTO assemblies (project_id, name)
SELECT
    (random()*19 + 1)::int,
    'Assembly_' || i
FROM generate_series(1,100) i;


INSERT INTO assembly_components (assembly_id, component_id, quantity)
SELECT
    (random()*99 + 1)::int,
    (random()*299 + 1)::int,
    (random()*5 + 1)::int
FROM generate_series(1,400);


INSERT INTO sensors (type, accuracy)
SELECT
    (ARRAY['Strain Gauge','Thermocouple','Accelerometer','Pressure'])[1 + (random()*3)::int],
    random()*0.01
FROM generate_series(1,20);


INSERT INTO tests (component_id, sensor_id, test_type, test_date)
SELECT
    (random()*299 + 1)::int,
    (random()*19 + 1)::int,
    (ARRAY['Fatigue','Thermal','Vibration','Static Load'])[1 + (random()*3)::int],
    CURRENT_DATE - (random()*365)::int
FROM generate_series(1,200);


INSERT INTO simulations (component_id, simulation_type, mesh_size)
SELECT
    (random()*299 + 1)::int,
    (ARRAY['Static','Modal','Thermal','CFD'])[1 + (random()*3)::int],
    (random()*500000 + 10000)::int
FROM generate_series(1,150);


INSERT INTO simulation_results (simulation_id, max_stress_mpa, max_displacement_mm)
SELECT
    simulation_id,
    random()*800,
    random()*5
FROM simulations;

