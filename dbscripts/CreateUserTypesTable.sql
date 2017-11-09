DROP TABLE IF EXISTS UserTypes;
CREATE TABLE UserTypes (
    usertypeid INT NOT NULL,
    usertypename VARCHAR(32) NOT NULL,
    access_patients BOOLEAN,
    access_employees BOOLEAN,
    access_payrolls BOOLEAN,
    access_hospitals BOOLEAN,
    access_appointments BOOLEAN,
    access_users BOOLEAN,
    access_wards BOOLEAN,
    access_visits BOOLEAN,
    PRIMARY KEY (usertypeid)
);

