DROP TABLE IF EXISTS Users;
CREATE TABLE Users(
    userid SERIAL UNIQUE,
	username VARCHAR(32) UNIQUE NOT NULL,
	password TEXT NOT NULL,
	isActive BOOLEAN NOT NULL DEFAULT TRUE,
	name VARCHAR(32),
	typeid INT NOT NULL,
	PRIMARY KEY (userid),
	FOREIGN KEY (typeid) REFERENCES usertypes(usertypeid)
);