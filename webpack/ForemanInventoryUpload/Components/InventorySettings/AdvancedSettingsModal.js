import React from 'react';
import PropTypes from 'prop-types';
import { Modal, ModalVariant } from '@patternfly/react-core';
import { translate as __ } from 'foremanReact/common/I18n';
import AutoUploadSwitcher from '../AutoUploadSwitcher';
import HostObfuscationSwitcher from '../HostObfuscationSwitcher';
import ExcludePackagesSwitcher from '../ExcludePackagesSwitcher';
import IpsObfuscationSwitcher from '../IpsObfuscationSwitcher';

const AdvancedSettingsModal = ({ isModalOpen, setIsModalOpen }) => (
  <Modal
    title={__('Settings')}
    isOpen={isModalOpen}
    onClose={() => setIsModalOpen(false)}
    appendTo={() => document.getElementsByClassName('rh-cloud-page')[0]}
    variant={ModalVariant.small}
  >
    <p>
      {__(
        'Red Hat Inventory and Cloud Connector use shared settings. Required settings differ for both'
      )}
    </p>
    <AutoUploadSwitcher />
    <ExcludePackagesSwitcher />
    <HostObfuscationSwitcher />
    <IpsObfuscationSwitcher />
  </Modal>
);

AdvancedSettingsModal.propTypes = {
  isModalOpen: PropTypes.bool.isRequired,
  setIsModalOpen: PropTypes.func.isRequired,
};

export default AdvancedSettingsModal;
