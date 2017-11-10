const Sequelize = require('sequelize');
const sequelize = new Sequelize('Demo', 'postgres', 'postgres', {
    host: 'localhost',
    port: 5433,
    dialect: 'postgres',
    pool: {
        max: 10,
        min: 0,
        idle: 30000
    },
    define: {
        timestamps: false
    }
});

/*

For John

 const Sequelize = require('sequelize');
 const sequelize = new Sequelize('postgres', 'postgres', 'postgres', {
 host: 'localhost',
 port: 5432,
 dialect: 'postgres',
 pool: {
 max: 10,
 min: 0,
 idle: 30000
 },
 define: {
 timestamps: false
 }
 });

 module.exports = sequelize; */