module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.eex',
    '../lib/**/*.leex'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    container: {
      center: true,
    },
    extend: {
      screens: {
        'sm': '680px'
      },
      fontFamily: {
        'sans': '"Lato", "Helvetica Neue", Helvetica, Arial, sans-serif'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
