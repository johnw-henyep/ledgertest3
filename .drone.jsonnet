local deployDir = '.drone/';
local inventoryFile = 'inventory';
local playbookFile = 'playbook.yml';

local ansibleVer = '3';

local checkPlaybookSyntax = {
  name: 'check syntax for playbook:' + playbookFile,
  image: 'plugins/ansible:' + ansibleVer,
  settings: {
    inventory: deployDir + inventoryFile,
    playbook: deployDir + playbookFile,
    syntax_check: true,
  },
};

local runPlaybook(env) = {
  name: 'deploy playbook with env:' + env,
  image: 'plugins/ansible:' + ansibleVer,
  environment: {
    TARGET_IP: { "from_secret": "TARGET_IP_" + std.asciiUpper(env) },
    SYNC_DST: { "from_secret": "SYNC_DST_" + std.asciiUpper(env) },
    FILE_USER: { "from_secret": "FILE_USER_" + std.asciiUpper(env) },
    FILE_GROUP: { "from_secret": "FILE_GROUP_" + std.asciiUpper(env) },

    CIRCLE_PAYMENT_HUB_PASSWORD: { "from_secret": "CIRCLE_PAYMENT_HUB_PASSWORD_" + std.asciiUpper(env) },
    CIRCLE_PAYMENT_HUB_URL: { "from_secret": "CIRCLE_PAYMENT_HUB_URL_" + std.asciiUpper(env) },
    CIRCLE_PAYMENT_HUB_USERCODE: { "from_secret": "CIRCLE_PAYMENT_HUB_USERCODE_" + std.asciiUpper(env) },
    CRYPTOCOMPARE_COM_API_KEY: { "from_secret": "CRYPTOCOMPARE_COM_API_KEY_" + std.asciiUpper(env) },
    DATASOURCES_DATABASE: { "from_secret": "DATASOURCES_DATABASE_" + std.asciiUpper(env) },
    DATASOURCES_HOST: { "from_secret": "DATASOURCES_HOST_" + std.asciiUpper(env) },
    DATASOURCES_PASSWORD: { "from_secret": "DATASOURCES_PASSWORD_" + std.asciiUpper(env) },
    DATASOURCES_USERNAME: { "from_secret": "DATASOURCES_USERNAME_" + std.asciiUpper(env) },
    DB_DEFAULT_DATABASE: { "from_secret": "DB_DEFAULT_DATABASE_" + std.asciiUpper(env) },
    DB_DEFAULT_PASSWORD: { "from_secret": "DB_DEFAULT_PASSWORD_" + std.asciiUpper(env) },
    DB_DEFAULT_USERNAME: { "from_secret": "DB_DEFAULT_USERNAME_" + std.asciiUpper(env) },
    DB_TEST_DATABASE: { "from_secret": "DB_TEST_DATABASE_" + std.asciiUpper(env) },
    DB_TEST_PASSWORD: { "from_secret": "DB_TEST_PASSWORD_" + std.asciiUpper(env) },
    DB_TEST_USERNAME: { "from_secret": "DB_TEST_USERNAME_" + std.asciiUpper(env) },
    DCI_ENDPOINT: { "from_secret": "DCI_ENDPOINT_" + std.asciiUpper(env) },
    DCI_SYSTEM_HASH: { "from_secret": "DCI_SYSTEM_HASH_" + std.asciiUpper(env) },
    DCI_WS_ENDPOINT: { "from_secret": "DCI_WS_ENDPOINT_" + std.asciiUpper(env) },
    DEBUGKIT_DATABASE: { "from_secret": "DEBUGKIT_DATABASE_" + std.asciiUpper(env) },
    DEBUGKIT_PASSWORD: { "from_secret": "DEBUGKIT_PASSWORD_" + std.asciiUpper(env) },
    DEBUGKIT_USERNAME: { "from_secret": "DEBUGKIT_USERNAME_" + std.asciiUpper(env) },
    EMAIL_SERVER_HOST: { "from_secret": "EMAIL_SERVER_HOST_" + std.asciiUpper(env) },
    EMAIL_SERVER_PASSWORD: { "from_secret": "EMAIL_SERVER_PASSWORD_" + std.asciiUpper(env) },
    EMAIL_SERVER_PORT: { "from_secret": "EMAIL_SERVER_PORT_" + std.asciiUpper(env) },
    EMAIL_SERVER_USERNAME: { "from_secret": "EMAIL_SERVER_USERNAME_" + std.asciiUpper(env) },
    KYT_KEY: { "from_secret": "KYT_KEY_" + std.asciiUpper(env) },
    KYT_URL: { "from_secret": "KYT_URL_" + std.asciiUpper(env) },
    Q9_CAPITAL_LEDGER_LOGIN: { "from_secret": "Q9_CAPITAL_LEDGER_LOGIN_" + std.asciiUpper(env) },
    Q9_CAPITAL_LEDGER_PASSWORD: { "from_secret": "Q9_CAPITAL_LEDGER_PASSWORD_" + std.asciiUpper(env) },
    Q9_CAPITAL_LEDGER_URL: { "from_secret": "Q9_CAPITAL_LEDGER_URL_" + std.asciiUpper(env) },
    Q9_CLIENT_PORTAL: { "from_secret": "Q9_CLIENT_PORTAL_" + std.asciiUpper(env) },
    S3_ACCESS_KEY: { "from_secret": "S3_ACCESS_KEY_" + std.asciiUpper(env) },
    S3_BUCKET: { "from_secret": "S3_BUCKET_" + std.asciiUpper(env) },
    S3_SECRET_KEY: { "from_secret": "S3_SECRET_KEY_" + std.asciiUpper(env) },
    SALESFORCE_API_URL: { "from_secret": "SALESFORCE_API_URL_" + std.asciiUpper(env) },
    SALESFORCE_PASSWORD: { "from_secret": "SALESFORCE_PASSWORD_" + std.asciiUpper(env) },
    SALESFORCE_URL: { "from_secret": "SALESFORCE_URL_" + std.asciiUpper(env) },
    SALESFORCE_USERNAME: { "from_secret": "SALESFORCE_USERNAME_" + std.asciiUpper(env) },
    SECURITY_SALT: { "from_secret": "SECURITY_SALT_" + std.asciiUpper(env) },
    WCMAIL_HOST: { "from_secret": "WCMAIL_HOST_" + std.asciiUpper(env) },
    WCMAIL_PASSWORD: { "from_secret": "WCMAIL_PASSWORD_" + std.asciiUpper(env) },
    WCMAIL_PORT: { "from_secret": "WCMAIL_PORT_" + std.asciiUpper(env) },
    WCMAIL_TIMEOUT: { "from_secret": "WCMAIL_TIMEOUT_" + std.asciiUpper(env) },
    WCMAIL_USERNAME: { "from_secret": "WCMAIL_USERNAME_" + std.asciiUpper(env) },
  },
  settings: {
    inventory: deployDir + inventoryFile,
    playbook: deployDir + playbookFile,
    tags: env,
    user: { "from_secret": "SSH_USER" },
    private_key: { "from_secret": "SSH_KEY" },
    become: true,
    become_method: "sudo",
  },
  commands: [
    'sed -i -r '
      + '-e "s|__TARGET_IP__|$TARGET_IP|g" '
      + '-e "s|__SYNC_DST__|$SYNC_DST|g" '
      + '-e "s|__FILE_USER__|$FILE_USER|g" '
      + '-e "s|__FILE_GROUP__|$FILE_GROUP|g" '
      + deployDir + inventoryFile,
    'sed -i -r '
      + '-e "s|__CIRCLE_PAYMENT_HUB_PASSWORD__|$CIRCLE_PAYMENT_HUB_PASSWORD|g" '
      + '-e "s|__CIRCLE_PAYMENT_HUB_URL__|$CIRCLE_PAYMENT_HUB_URL|g" '
      + '-e "s|__CIRCLE_PAYMENT_HUB_USERCODE__|$CIRCLE_PAYMENT_HUB_USERCODE|g" '
      + '-e "s|__CRYPTOCOMPARE_COM_API_KEY__|$CRYPTOCOMPARE_COM_API_KEY|g" '
      + '-e "s|__DATASOURCES_DATABASE__|$DATASOURCES_DATABASE|g" '
      + '-e "s|__DATASOURCES_HOST__|$DATASOURCES_HOST|g" '
      + '-e "s|__DATASOURCES_PASSWORD__|$DATASOURCES_PASSWORD|g" '
      + '-e "s|__DATASOURCES_USERNAME__|$DATASOURCES_USERNAME|g" '
      + '-e "s|__DB_DEFAULT_DATABASE__|$DB_DEFAULT_DATABASE|g" '
      + '-e "s|__DB_DEFAULT_PASSWORD__|$DB_DEFAULT_PASSWORD|g" '
      + '-e "s|__DB_DEFAULT_USERNAME__|$DB_DEFAULT_USERNAME|g" '
      + '-e "s|__DB_TEST_DATABASE__|$DB_TEST_DATABASE|g" '
      + '-e "s|__DB_TEST_PASSWORD__|$DB_TEST_PASSWORD|g" '
      + '-e "s|__DB_TEST_USERNAME__|$DB_TEST_USERNAME|g" '
      + '-e "s|__DCI_ENDPOINT__|$DCI_ENDPOINT|g" '
      + '-e "s|__DCI_SYSTEM_HASH__|$DCI_SYSTEM_HASH|g" '
      + '-e "s|__DCI_WS_ENDPOINT__|$DCI_WS_ENDPOINT|g" '
      + '-e "s|__DEBUGKIT_DATABASE__|$DEBUGKIT_DATABASE|g" '
      + '-e "s|__DEBUGKIT_PASSWORD__|$DEBUGKIT_PASSWORD|g" '
      + '-e "s|__DEBUGKIT_USERNAME__|$DEBUGKIT_USERNAME|g" '
      + '-e "s|__EMAIL_SERVER_HOST__|$EMAIL_SERVER_HOST|g" '
      + '-e "s|__EMAIL_SERVER_PASSWORD__|$EMAIL_SERVER_PASSWORD|g" '
      + '-e "s|__EMAIL_SERVER_PORT__|$EMAIL_SERVER_PORT|g" '
      + '-e "s|__EMAIL_SERVER_USERNAME__|$EMAIL_SERVER_USERNAME|g" '
      + '-e "s|__KYT_KEY__|$KYT_KEY|g" '
      + '-e "s|__KYT_URL__|$KYT_URL|g" '
      + '-e "s|__Q9_CAPITAL_LEDGER_LOGIN__|$Q9_CAPITAL_LEDGER_LOGIN|g" '
      + '-e "s|__Q9_CAPITAL_LEDGER_PASSWORD__|$Q9_CAPITAL_LEDGER_PASSWORD|g" '
      + '-e "s|__Q9_CAPITAL_LEDGER_URL__|$Q9_CAPITAL_LEDGER_URL|g" '
      + '-e "s|__Q9_CLIENT_PORTAL__|$Q9_CLIENT_PORTAL|g" '
      + '-e "s|__S3_ACCESS_KEY__|$S3_ACCESS_KEY|g" '
      + '-e "s|__S3_BUCKET__|$S3_BUCKET|g" '
      + '-e "s|__S3_SECRET_KEY__|$S3_SECRET_KEY|g" '
      + '-e "s|__SALESFORCE_API_URL__|$SALESFORCE_API_URL|g" '
      + '-e "s|__SALESFORCE_PASSWORD__|$SALESFORCE_PASSWORD|g" '
      + '-e "s|__SALESFORCE_URL__|$SALESFORCE_URL|g" '
      + '-e "s|__SALESFORCE_USERNAME__|$SALESFORCE_USERNAME|g" '
      + '-e "s|__SECURITY_SALT__|$SECURITY_SALT|g" '
      + '-e "s|__WCMAIL_HOST__|$WCMAIL_HOST|g" '
      + '-e "s|__WCMAIL_PASSWORD__|$WCMAIL_PASSWORD|g" '
      + '-e "s|__WCMAIL_PORT__|$WCMAIL_PORT|g" '
      + '-e "s|__WCMAIL_TIMEOUT__|$WCMAIL_TIMEOUT|g" '
      + '-e "s|__WCMAIL_USERNAME__|$WCMAIL_USERNAME|g" '
      + './config/app.php ./config/app_local.php',
    '/bin/drone-ansible',
  ],
};

local notify = {
  name: 'notify via email',
  image: 'drillster/drone-email',
  settings: {
    host: { "from_secret": "MAIL_HOST" },
    port: { "from_secret": "MAIL_PORT" },
    skip_verify: true,
    from: "cicd@hko.henyep.com",
   recipients: [
     "ken.cheng@henyep.com",
     "john.wong@henyep.com",
   ],
  },
  when: {
    status: [
      'success',
      'failure',
    ],
  },
};

local whenEnv(env) = {
  when: {
    branch: [] + (
    if env == 'production' then [
      'production',
    ] else [
      'test',
    ]
    ),
  }
};

[
{
  kind: 'pipeline',
  name: 'default',
  type: 'docker',
  trigger: {
    branch: [
      'production',
      'test',
    ],
  },
  steps: [
    checkPlaybookSyntax,
    runPlaybook('production') + whenEnv('production'),
    runPlaybook('test') + whenEnv('test'),
    notify,
  ],
},
]
