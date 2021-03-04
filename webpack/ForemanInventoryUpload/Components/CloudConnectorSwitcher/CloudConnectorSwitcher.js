import React, { useState } from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import ShortSwitcherPF4 from '../../../common/Switcher/ShortSwitcherPF4';

const CloudConnectorSwitcher = () => {
  const [cloudConnectorEnabled, setCloudConnectorEnabled] = useState(false);
  return (
    <ShortSwitcherPF4
      id="cloud-connector-settings-switcher"
      label={__('Cloud Connector')}
      isChecked={cloudConnectorEnabled}
      onChange={newIsChecked => setCloudConnectorEnabled(newIsChecked)}
    />
  );
};

export default CloudConnectorSwitcher;
