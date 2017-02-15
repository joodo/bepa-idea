#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QRectF>
#include <QQuickItem>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QString>
#include <QQmlComponent>
#include <QSettings>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0) {Q_UNUSED(parent);}
signals:

public slots:
    static bool rectContains(const QRectF& bigRect, const QRectF& smallRect);
    static void setItemRect(QQuickItem *item, const QRectF& rect);
    static QRectF itemRect(QQuickItem *item);

    static QJsonObject loadJsonFromFile(const QString& filePath);
    static bool saveJsonToFile(const QJsonObject& data, const QString& filePath);

    static QQuickItem* createItem(QQuickItem* parent, QQmlComponent* component);
    static QQuickItem* createItem(QQuickItem* parent, const QString& componentFile);

    static QString url2Path(const QUrl& url);
    static QString url2Name(const QUrl& url);
    static QUrl fileFolderUrl(const QUrl& url);
    static QUrl changeUrlFileName(const QUrl& url, const QString& newName);

    static QVariant settingValue(const QString& key);
    static QVariant settingValue(const QString& key, const QVariant &defaultValue);
    static void setSettingValue(const QString& key, const QVariant& value);
    static bool settingContains(const QString &key);

    static bool renameFile(const QUrl& fileUrl, const QString& newName);

private:
    static QSettings m_settings;
};

#endif // UTILS_H
