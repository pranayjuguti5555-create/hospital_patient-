CREATE DATABASE careplus_hospital_db;

USE careplus_hospital_db;
select * from appointments;
select * from doctors;
select * from patients;
select * from rooms;
select * from treatments;
DESCRIBE appointments;
ALTER TABLE appointments
MODIFY appointment_id VARCHAR(20) NOT NULL;

ALTER TABLE appointments
ADD PRIMARY KEY (appointment_id);

ALTER TABLE appointments
MODIFY patient_id VARCHAR(20);
ALTER TABLE appointments
ADD CONSTRAINT fk_appointments_patients
FOREIGN KEY (patient_id)
REFERENCES patients(patient_id);

ALTER TABLE appointments
MODIFY doctor_id VARCHAR(10);

ALTER TABLE appointments
ADD CONSTRAINT fk_appointments_doctors
FOREIGN KEY (doctor_id)
REFERENCES doctors(doctor_id);


show create table appointments;

DESCRIBE patients;
ALTER TABLE patients
MODIFY patient_id VARCHAR(20) NOT NULL;

ALTER TABLE patients
ADD PRIMARY KEY (patient_id);
show create table patients;

DESCRIBE doctors;
alter table doctors
modify doctor_id varchar(20) not null;

alter table doctors 
add primary key(doctor_id);
show create table doctors;

describe rooms;
alter table rooms
modify room_id varchar(20) not null;

alter table rooms
add primary key (room_id);
show create table rooms;

describe treatments ;
alter table treatments
modify treatment_id varchar(20) not null;

alter table treatments
add primary key (treatment_id);
show create table treatments;

ALTER TABLE treatments
MODIFY treatment_id VARCHAR(20) NOT NULL,
MODIFY appointment_id VARCHAR(20),
MODIFY doctor_id VARCHAR(10),
MODIFY room_id VARCHAR(10);

ALTER TABLE treatments
ADD CONSTRAINT fk_treatments_appointments
FOREIGN KEY (appointment_id)
REFERENCES appointments(appointment_id);

ALTER TABLE treatments
ADD CONSTRAINT fk_treatments_doctors
FOREIGN KEY (doctor_id)
REFERENCES doctors(doctor_id);

ALTER TABLE treatments
ADD CONSTRAINT fk_treatments_rooms
FOREIGN KEY (room_id)
REFERENCES rooms(room_id);

--  we will get ERR diagram here

-- Sprint 1.3

-- 1. what is the total number of patients?
select count(*) as total_patients
from patients;

-- 2. what is the total number of appointments?
select count(*) as total_appointments
from appointments;

-- 3. what is the total number of treatment records?
select count(*) as total_treatments
from treatments;

-- 4. what are the different medical service types?
select distinct service_type
from appointments
order by service_type;

-- 5. how many doctors are currently active?
select count(*) as active_doctors
from doctors
where is_active = 'yes';
select * from doctors

-- 6. what are the different room types?
select distinct room_type
from rooms
order by room_type;

-- 7. what is the total estimated appointment value?
select sum(estimated_cost) as total_estimated_value
from appointments;

-- 8. what is the average treatment duration?
select round(avg(treatment_duration_min), 2) as avg_treatment_duration
from treatments;

SELECT
    patient_id,
    COUNT(*) AS appointment_count
FROM appointments
GROUP BY patient_id
HAVING COUNT(*) > 1
ORDER BY appointment_count DESC;


SELECT
    p.patient_id,
    p.patient_name,
    SUM(a.estimated_cost) AS total_estimated_value
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY total_estimated_value DESC
LIMIT 10;

SELECT
    status,
    COUNT(*) AS treatment_count,
    ROUND(100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM treatments), 2) AS percentage
FROM treatments
GROUP BY status
ORDER BY treatment_count DESC;


SELECT
    status,
    COUNT(*) AS total_records,
    ROUND(AVG(waiting_time_min), 2) AS avg_waiting_time,
    ROUND(AVG(treatment_duration_min), 2) AS avg_duration
FROM treatments
GROUP BY status
ORDER BY avg_waiting_time DESC;

SELECT
    d.doctor_id,
    d.doctor_name,
    COUNT(t.treatment_id) AS total_treatments
FROM doctors d
JOIN treatments t
    ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_treatments DESC;

SELECT
    r.room_type,
    COUNT(t.treatment_id) AS total_treatments
FROM rooms r
LEFT JOIN treatments t
    ON r.room_id = t.room_id
GROUP BY r.room_type
ORDER BY total_treatments DESC;

SELECT
    service_type,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY service_type
ORDER BY total_appointments DESC;

SELECT
    p.city,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY total_appointments DESC;

SELECT
    a.priority,
    COUNT(t.treatment_id) AS total_treatments,
    ROUND(AVG(t.waiting_time_min), 2) AS avg_waiting_time
FROM appointments a
JOIN treatments t
    ON a.appointment_id = t.appointment_id
GROUP BY a.priority
ORDER BY avg_waiting_time DESC;

SELECT
    status,
    COUNT(*) AS total_treatments,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM treatments), 2
    ) AS percentage
FROM treatments
GROUP BY status
ORDER BY total_treatments DESC;





