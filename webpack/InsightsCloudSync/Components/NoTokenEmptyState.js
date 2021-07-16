/* eslint-disable translation/no-strings-without-translations */
import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import {
  Button,
  TextInput,
  FormGroup,
  GridItem,
  Grid,
  EmptyState,
  EmptyStateIcon,
  EmptyStateVariant,
  EmptyStateBody,
} from '@patternfly/react-core';
import { ExternalLinkAltIcon, RocketIcon } from '@patternfly/react-icons';
import { post } from 'foremanReact/redux/API';
import { translate as __ } from 'foremanReact/common/I18n';
import { INSIGHTS_SAVE_AND_SYNC_PATH } from '../InsightsCloudSyncConstants';
import { INSIGHTS_HITS_API_KEY } from './InsightsTable/InsightsTableConstants';

export const NoTokenEmptyState = () => {
  const [token, setToken] = useState('');
  const dispatch = useDispatch();
  const onSave = () => {
    dispatch(
      post({
        key: INSIGHTS_HITS_API_KEY,
        url: INSIGHTS_SAVE_AND_SYNC_PATH,
        params: { value: token },
      })
    );
  };
  return (
    <EmptyState variant={EmptyStateVariant.xl}>
      <EmptyStateIcon icon={RocketIcon} />
      <EmptyStateBody>
        <p>
          {__(`Insights synchronization process is used to provide Insights
               recommendations output for hosts managed here`)}
        </p>
        <p>
          {__(
            `To use recommendations please add a token to 'Red Hat Cloud token' setting here or in the settings page`
          )}
          <br />
          {__(`You can obtain a Red Hat API token here: `)}
          <a
            href="https://access.redhat.com/management/api"
            target="_blank"
            rel="noopener noreferrer"
          >
            access.redhat.com <ExternalLinkAltIcon />
          </a>
          <br />
        </p>

        <br />
        <FormGroup
          label={__('Red Hat Cloud token:')}
          fieldId="input-cloud-token"
        >
          <Grid>
            <GridItem span={3} />
            <GridItem span={6}>
              <TextInput
                value={token}
                type="password"
                onChange={newValue => setToken(newValue)}
                aria-label="input-cloud-token"
              />
            </GridItem>
          </Grid>
        </FormGroup>
      </EmptyStateBody>
      <Button variant="primary" onClick={onSave} isDisabled={!token.length}>
        {__('Save setting and sync recommendations')}
      </Button>
    </EmptyState>
  );
};
