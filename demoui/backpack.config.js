module.exports = {
  webpack: (config, options, webpack) => {
    config.entry.main = './server/home.js'
    return config
  }
}
