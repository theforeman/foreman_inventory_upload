import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { Text, TextVariants, Popover, Button } from '@patternfly/react-core';
import { InfoAltIcon, CaretRightIcon } from '@patternfly/react-icons';
import { FormGroup, Grid } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import { foremanUrl } from '../../../ForemanRhCloudHelpers';
import Switcher from '../../../common/Switcher';
import AdvancedSettings from './components/AdvancedSettings';
import { settingsDict } from '../../Components/InventorySettings/AdvancedSetting/AdvancedSettingsConstants';

const InventoryAutoUploadSwitcher = ({
  autoUploadEnabled,
  setSetting,
  getSettings,
}) => {
  useEffect(() => {
    getSettings();
  }, [getSettings]);
  const handleToggle = () =>
    setSetting({
      setting: settingsDict.autoUploadEnabled.name,
      value: !autoUploadEnabled,
    });
  return (
    <FormGroup>
      <Grid>
        <h3>{__('Red Hat Cloud Inventory')}</h3>
        <hr />
        <Grid.Row>
          <Switcher
            id="auto-upload"
            label={__('Inventory Auto Upload')}
            tooltip={__(
              'Enable automatic upload of your hosts inventory to the Red Hat cloud'
            )}
            isChecked={autoUploadEnabled}
            onChange={handleToggle}
            labelCol={5}
          />

          <Grid.Col sm={5}>
            <Popover
              headerContent={
                <strong>{__('Advanced Inventory Settings')}</strong>
              }
              bodyContent={
                <AdvancedSettings
                  autoUploadEnabled={autoUploadEnabled}
                  handleToggle={handleToggle}
                />
              }
              position="right"
            >
              <Button
                variant="secondary"
                style={{ fontSize: 'small', marginTop: '-4px' }}
              >
                {__('Show Advanced Settings')} <CaretRightIcon />
              </Button>
            </Popover>
          </Grid.Col>
        </Grid.Row>
        <br />
        <Grid.Row>
          <Grid.Col sm={12}>
            <Text component={TextVariants.p}>
              <InfoAltIcon /> {__('More details can be found in')}{' '}
              <Text
                component={TextVariants.a}
                href={foremanUrl('/foreman_rh_cloud/inventory_upload')}
                target="_blank"
                rel="noopener noreferrer"
              >
                <strong>
                  {__('Configure')}
                  {' > '}
                  {__('Inventory Upload')}
                </strong>
              </Text>
            </Text>
          </Grid.Col>
        </Grid.Row>
      </Grid>
    </FormGroup>
  );
};

InventoryAutoUploadSwitcher.propTypes = {
  autoUploadEnabled: PropTypes.bool,
  setSetting: PropTypes.func.isRequired,
  getSettings: PropTypes.func.isRequired,
};

InventoryAutoUploadSwitcher.defaultProps = {
  autoUploadEnabled: true,
};

export default InventoryAutoUploadSwitcher;
