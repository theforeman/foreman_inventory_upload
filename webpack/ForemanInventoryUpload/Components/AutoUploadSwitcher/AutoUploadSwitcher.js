import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import SwitcherPF4 from '../../../common/Switcher/SwitcherPF4';

const AutoUploadSwitcher = ({ autoUploadEnabled, handleToggle }) => (
  <div className="auto_upload_switcher">
    <SwitcherPF4
      id="auto-upload-setting-switcher"
      label={`${__('Auto upload')} ${__('(enabled by default)')}`}
      tooltip={__(
        'Enable automatic upload of your hosts inventory to the Red Hat cloud'
      )}
      isChecked={autoUploadEnabled}
      onChange={() => handleToggle(autoUploadEnabled)}
    />
  </div>
);

AutoUploadSwitcher.propTypes = {
  autoUploadEnabled: PropTypes.bool,
  handleToggle: PropTypes.func.isRequired,
};

AutoUploadSwitcher.defaultProps = {
  autoUploadEnabled: true,
};

export default AutoUploadSwitcher;
