import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Switch, FieldLevelHelp } from 'patternfly-react';
import { translate as __ } from 'foremanReact/common/I18n';
import './insightsSyncSwitcher.scss';

class InsightsSyncSwitcher extends Component {
  handleToggle = () => {
    const { insightsSyncEnabled, setInsightsSyncEnabled } = this.props;

    const toggledInsightsSyncEnabled = !insightsSyncEnabled;
    setInsightsSyncEnabled(toggledInsightsSyncEnabled);
  };

  render() {
    const { insightsSyncEnabled } = this.props;

    return (
      <div className="insights_sync_switcher">
        <span>{__('Synchronize Automatically')}</span>
        <FieldLevelHelp
          content={__(
            'Enable automatic synchronization of Insights recommendations from the Red Hat cloud'
          )}
        />
        <Switch
          size="mini"
          value={insightsSyncEnabled}
          onChange={this.handleToggle}
        />
      </div>
    );
  }
}

InsightsSyncSwitcher.propTypes = {
  insightsSyncEnabled: PropTypes.bool,
  setInsightsSyncEnabled: PropTypes.func.isRequired,
};

InsightsSyncSwitcher.defaultProps = {
  insightsSyncEnabled: true,
};

export default InsightsSyncSwitcher;
