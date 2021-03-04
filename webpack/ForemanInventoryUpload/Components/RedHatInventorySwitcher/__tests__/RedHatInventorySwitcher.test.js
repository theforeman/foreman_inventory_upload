import { testComponentSnapshotsWithFixtures } from '@theforeman/test';

import RedHatInventorySwitcher from '../RedHatInventorySwitcher';

const fixtures = {
  render: {},
};

describe('RedHatInventorySwitcher', () => {
  describe('rendering', () =>
    testComponentSnapshotsWithFixtures(RedHatInventorySwitcher, fixtures));
});
