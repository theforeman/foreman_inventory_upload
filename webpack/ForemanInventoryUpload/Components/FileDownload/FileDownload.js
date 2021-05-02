import React from 'react';
import PropTypes from 'prop-types';
import { Grid, Button, Icon } from 'patternfly-react';
import { noop } from 'foremanReact/common/helpers';
import { translate as __ } from 'foremanReact/common/I18n';

import './fileDownload.scss';

const FileDownload = ({ onClick }) => (
  <Grid.Col sm={12}>
    <Button onClick={onClick} className="download-button">
      {__('Download Report')} <Icon name="download" />
    </Button>
  </Grid.Col>
);

FileDownload.propTypes = {
  onClick: PropTypes.func,
};

FileDownload.defaultProps = {
  onClick: noop,
};

export default FileDownload;
