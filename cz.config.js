/** @type {import('czg').UserConfig['prompt']} */
module.exports = {
  types: [
    {
      value: '📌Added',
      name: 'Add',
    },
    {
      value: '🐛Fixed',
      name: 'Fix',
    },
    {
      value: '🔧Changed',
      name: 'Change',
    },
    {
      value: '🗑️Removed',
      name: 'Remove',
    },
    {
      value: '♻️Refactored',
      name: 'Refactor',
    },
    {
      value: '♻️Improved',
      name: 'Improve',
    },
    {
      value: '🧹CleanUp',
      name: 'CleanUp',
    },
  ],

  formatMessageCB: ({ type, subject }) => {
    return `[${type}]: ${subject}`
  },

  skipQuestions: [
    'scope',
    'body',
    'breaking',
    'footerPrefix',
    'footer',
  ],
}