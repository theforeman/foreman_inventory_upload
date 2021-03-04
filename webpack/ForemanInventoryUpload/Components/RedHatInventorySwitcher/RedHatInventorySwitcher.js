import React, { useState } from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import ShortSwitcherPF4 from '../../../common/Switcher/ShortSwitcherPF4';

const RedHatInventorySwitcher = () => {
  const [redHatInventoryEnabled, setRedHatInventoryEnabled] = useState(false);
  return (
    <ShortSwitcherPF4
      id="rh-inventory-settings-switcher"
      label={__('Red Hat Inventory')}
      isChecked={redHatInventoryEnabled}
      onChange={newIsChecked => setRedHatInventoryEnabled(newIsChecked)}
    />
  );
};

export default RedHatInventorySwitcher;
