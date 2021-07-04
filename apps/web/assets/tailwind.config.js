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
        'screen': 'var(--space)',
        'mobile': 'var(--space-mobile)',
        'bar': 'var(--bar)',
        'mbar': 'var(--bar-mobile)',
        'bar2': 'var(--bar2)',
        'mbar2': 'var(--bar2-mobile)',
        'cta': 'var(--cta)',
        'mcta': 'var(--cta-mobile)',
        'sc': 'var(--space)',
        'mb': 'var(--space-mobile)'
      },
    },
  },
  variants: {
    extend: {
      display: ['last'],
      borderWidth: ['hover', 'focus'],
      cursor: ['disabled'],
      textColor: ['disabled'],
      backgroundColor: ['disabled'],
      margin: ['last']
    },
  },
  plugins: [],
  corePlugins: {
    container: false
  }
}
