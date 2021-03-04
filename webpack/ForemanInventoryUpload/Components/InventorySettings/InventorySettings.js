import React, { useState } from 'react';
import { translate as __ } from 'foremanReact/common/I18n';
import { Button } from '@patternfly/react-core';
import AdvancedSettingsModal from './AdvancedSettingsModal';
import RedHatInventorySwitcher from '../RedHatInventorySwitcher';
import CloudConnectorSwitcher from '../CloudConnectorSwitcher';
import './InventorySettings.scss';

const InventorySettings = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  return (
    <div className="inventory-settings">
      <h3>{__('Settings')}</h3>
      <RedHatInventorySwitcher />
      <CloudConnectorSwitcher />
      <Button variant="link" isInline onClick={() => setIsModalOpen(true)}>
        {__('View advanced settings')}
      </Button>
      <AdvancedSettingsModal
        isModalOpen={isModalOpen}
        setIsModalOpen={setIsModalOpen}
      />
    </div>
  );
};

export default InventorySettings;
