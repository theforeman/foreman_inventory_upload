/* eslint-disable react-hooks/exhaustive-deps */
import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { FormGroup, TextInput } from '@patternfly/react-core';
import { noop } from 'foremanReact/common/helpers';
import { translate as __ } from 'foremanReact/common/I18n';
import ClearButton from './Components/ClearButton';
import './inventoryFilter.scss';
import { ANY_ORGANIZATION } from './InventoryFilterConstants';

const InventoryFilter = ({
  handleFilterChange,
  handleFilterClear,
  filterTerm,
  organization,
}) => {
  useEffect(() => {
    const initialTerm = organization === ANY_ORGANIZATION ? '' : organization;
    handleFilterChange(initialTerm);
  }, []);

  return (
    <form id="inventory_filter_form">
      <FormGroup>
        <TextInput
          id="inventory_filter_input"
          value={filterTerm}
          type="text"
          placeholder={__('Filter..')}
          onChange={handleFilterChange}
        />
        <ClearButton onClear={handleFilterClear} />
      </FormGroup>
    </form>
  );
};

InventoryFilter.propTypes = {
  handleFilterChange: PropTypes.func,
  handleFilterClear: PropTypes.func,
  filterTerm: PropTypes.string,
  organization: PropTypes.string,
};

InventoryFilter.defaultProps = {
  handleFilterChange: noop,
  handleFilterClear: noop,
  filterTerm: '',
  organization: '',
};

export default InventoryFilter;
