import React from 'react';
import { EmptyState, Spinner } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import './emptyState.scss';

const inventoryEmptyState = () => (
  <EmptyState>
    <Spinner loading inline size="lg" />
    <EmptyState.Title>
      {__('Fetching data about your accounts')}
    </EmptyState.Title>
    <EmptyState.Info>{__('Loading...')}</EmptyState.Info>
  </EmptyState>
);

export default inventoryEmptyState;
