module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    colors: {
      'tan': '#E3E6C0',
      'olive': '#BEC645',
      'sea-green': '#819D49',
      'forest-green': '#5A8359',
      'night-green': '#112810',
      green: {
        pale: '#E3E6C0',
        light: '#BEC645',
        base: '#819D49',
        dark: '#5A8359',
        darkest: '#112810',
      },
      blueorange: {
        pale: '#F7E3D4',
        light: '#FDDC22',
        base: '#FC7307',
        dark: '#183BF0',
        darkest: '#342E09',
      },
      'th-pale': 'var(--pale)',
      'th-light': 'var(--light)',
      'th-base': 'var(--base)',
      'th-dark': 'var(--dark)',
      'th-darkest': 'var(--darkest)',

    },
    extend: {
    },
  },
  variants: {
    extend: {
      textDecoration: ['active'],
    },
  },
  plugins: [],
}
