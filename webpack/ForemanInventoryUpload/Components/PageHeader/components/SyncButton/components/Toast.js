import React from 'react';
import PropTypes from 'prop-types';
import { translate as __ } from 'foremanReact/common/I18n';
import { foremanUrl } from '../../../../../../ForemanRhCloudHelpers';

const Toast = ({ syncHosts, disconnectHosts }) => {
  const totalHosts = syncHosts + disconnectHosts;
  return (
    <span>
      <p>
        {__('Hosts with subscription in organization: ')}
        <strong>{totalHosts}</strong>
      </p>
      <p>
        {__('Successfully synced hosts: ')}
        <strong>{syncHosts}</strong>
      </p>
      <p>
        {__('Disconnected hosts: ')}
        <strong>{disconnectHosts}</strong>
      </p>
      <p>
        {__('For more info, please visit the')}{' '}
        <a
          href={foremanUrl('/hosts')}
          target="_blank"
          rel="noopener noreferrer"
        >
          {__('hosts page')}
        </a>
      </p>
    </span>
  );
};

Toast.propTypes = {
  syncHosts: PropTypes.number.isRequired,
  disconnectHosts: PropTypes.number.isRequired,
};

export default Toast;
