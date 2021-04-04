module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.eex',
    '../lib/**/*.leex'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      screens: {
        'sm': '680px'
      },
      fontFamily: {
        'sans': '"Lato", "Helvetica Neue", Helvetica, Arial, sans-serif'
      },
      spacing: {
        'sc': 'var(--space)',
        'mb': 'var(--space-mobile)'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
  corePlugins: {
    container: false
  }
}
