/* eslint-disable import/extensions */
import React from 'react';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';
import { registerReducer } from 'foremanReact/common/MountingService';
import reducers from './ForemanRhCloudReducers';
import InsightsHostDetailsTab from './InsightsHostDetailsTab';
import { subscriptionCountListener } from './ForemanInventoryUpload/SubscriptionsPageExtension/SubscriptionsPageExtensionActions';

// Register reducers
Object.entries(reducers).forEach(([key, reducer]) =>
  registerReducer(key, reducer)
);

const [prefix, mainPath, subPath] = window.location.pathname.split('/');
switch (mainPath) {
  case 'subscriptions':
    window.tfm.store.observeStore(
      'katello.subscriptions.itemCount',
      subscriptionCountListener
    );
    break;
  case 'experimental':
    if (subPath === 'hosts') {
      const InsightsTab = ({ response }) => (
        <InsightsHostDetailsTab hostID={response.id} />
      );

      addGlobalFill('host-details-page-tabs', 'Insights', <InsightsTab />, 100);
    }
    break;
  default:
    break;
}
