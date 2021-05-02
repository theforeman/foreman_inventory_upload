import React from 'react';
import PropTypes from 'prop-types';
import { Icon, Modal, Grid, Button } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import { foremanUrl } from '../../../../../../ForemanRhCloudHelpers';
import './modal.scss';

const SyncModal = ({ show, toggleModal }) => (
  <Modal show={show} onHide={toggleModal} id="inventory-sync-modal">
    <Modal.Header>
      <button
        className="close"
        onClick={toggleModal}
        aria-hidden="true"
        aria-label="Close"
      >
        <Icon type="pf" name="close" />
      </button>
      <Modal.Title>{__('Token is required')}</Modal.Title>
    </Modal.Header>
    <Modal.Body>
      <Grid>
        <p>
          {__(`Please go over the following steps to add a Red Hat API token:`)}
        </p>
        <p>
          {__(`1. Obtain an Red Hat API token: `)}
          <a
            href="https://access.redhat.com/management/api"
            target="_blank"
            rel="noopener noreferrer"
          >
            access.redhat.com <Icon name="external-link" />
          </a>
          <br />
          {__("2. Copy the token to 'Red Hat Cloud token' setting: ")}
          <a
            href={foremanUrl('/settings?search=name+%3D+rh_cloud_token')}
            target="_blank"
            rel="noopener noreferrer"
          >
            {__('Red Hat Cloud token ')}
            <Icon name="external-link" />
          </a>
          <br />
          {__(
            '3. Now you can synchronize inventory status manually, by clicking the "Sync inventory status" button.'
          )}
        </p>
        <Button bsStyle="primary" bsSize="lg" onClick={toggleModal}>
          {__('Close')}
        </Button>
      </Grid>
    </Modal.Body>
  </Modal>
);

SyncModal.propTypes = {
  show: PropTypes.bool.isRequired,
  toggleModal: PropTypes.func.isRequired,
};

export default SyncModal;
