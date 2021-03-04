import React from 'react';
import PropTypes from 'prop-types';
import { Switch, Grid, GridItem } from '@patternfly/react-core';
import { HelpLabel } from './HelpLabel';
import './ShortSwitcherPF4.scss';

const ShortSwitcherPF4 = ({ id, label, tooltip, isChecked, onChange }) => (
  <Grid className="foreman-short-switcher">
    <GridItem span={9} className="switcher-label">
      {label}
      <HelpLabel text={tooltip} id={id} className="switcher-help-label" />
    </GridItem>
    <GridItem span={1} />
    <GridItem span={2}>
      <Switch
        id={`rh-cloud-switcher-${id}`}
        isChecked={isChecked}
        onChange={onChange}
      />
    </GridItem>
  </Grid>
);

ShortSwitcherPF4.propTypes = {
  id: PropTypes.string.isRequired,
  label: PropTypes.string,
  tooltip: PropTypes.string,
  isChecked: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
};

ShortSwitcherPF4.defaultProps = {
  label: null,
  tooltip: null,
  isChecked: true,
};

export default ShortSwitcherPF4;
