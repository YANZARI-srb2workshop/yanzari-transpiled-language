/** @type {import('czg').UserConfig['prompt']} */
module.exports = {
  breaklineChar: `\\`,
  types: [
    {
      value: 'added',
      name: 'added',
    },
    {
      value: 'fixed',
      name: 'fixed',
    },
    {
      value: 'changed',
      name: 'changed',
    },
    {
      value: 'removed',
      name: 'removed',
    },
    {
      value: 'refactored',
      name: 'refactored',
    },
    {
      value: 'improved',
      name: 'improved',
    },
    {
      value: 'cleanup',
      name: 'cleaned',
    },
    {
      value: 'i-forgot',
      name: 'i forgot',
    },
  ],

  formatMessageCB: ({ type, markBreaking, subject, body }) => {
    if (markBreaking.length>0) {
      return `breaking-changes:${type}: ${subject}

${body}`
    }
    return `${type}: ${subject}

${body}`
  },

  allowBreakingChanges: [
    "added",
    "changed",
    "fixed",
    "removed"
  ],
  markBreakingChangeMode: true,

  messages: {
    body: `Provide a LONGER description of the change (optional). Use "\\" to break new line:
`,
    markBreaking: 'Is any BREAKING CHANGE (optional)?',
  },

  skipQuestions: [
    'scope',
    'breaking',
    'footerPrefix',
    'footer',
  ],
}