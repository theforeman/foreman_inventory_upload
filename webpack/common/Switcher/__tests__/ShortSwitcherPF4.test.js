import { testComponentSnapshotsWithFixtures } from '@theforeman/test';
import ShortSwitcherPF4 from '../ShortSwitcherPF4';

const fixtures = {
  'should return insights cloud Url': {
    id: 'some-id',
    tooltip: 'some-text',
    label: 'some-label',
    onChange: jest.fn(),
  },
};

describe('InsightsCloudSync helpers', () =>
  testComponentSnapshotsWithFixtures(ShortSwitcherPF4, fixtures));
