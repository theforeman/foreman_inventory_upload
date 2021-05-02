import React from 'react';
import { translate as __ } from 'foremanReact/common/I18n';

export const PageDescription = () => (
  <div id="inventory_page_description">
    <p>
      {__(
        'Red Hat Insights is a set of cloud services which provide unified subscription reporting, predictive analysis and remediation of issues through this Satellite instance.'
      )}
    </p>
    <p>
      {__(
        'You can toggle the Auto upload switch to the ON position to enable Satellite to automatically upload your host inventory once a day.'
      )}
    </p>
    <p>
      {__(
        'Click Restart to upload your host inventory to Red Hat Insights. Perform this step for each organization from which you want to manually upload a host inventory.'
      )}
    </p>
    <p>
      {__(
        'Enabling inventory uploads is required by subscription watch. For more information about subscription watch see link:'
      )}
      &nbsp;
      <a
        href="https://access.redhat.com/documentation/en-us/subscription_central/2020-04/html/getting_started_with_subscription_watch/assembly-about-subscriptionwatch"
        target="_blank"
        rel="noopener noreferrer"
      >
        {__('About subscription watch')}
      </a>
    </p>
  </div>
);

export default PageDescription;
