import { testComponentSnapshotsWithFixtures } from '@theforeman/test';

import CloudConnectorSwitcher from '../CloudConnectorSwitcher';

const fixtures = {
  render: {},
};

describe('CloudConnectorSwitcher', () => {
  describe('rendering', () =>
    testComponentSnapshotsWithFixtures(CloudConnectorSwitcher, fixtures));
});
