#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QFileInfo>

#include "utils.h"

QSettings Utils::m_settings(QSettings::UserScope, "Bepa");

bool Utils::rectContains(const QRectF &bigRect, const QRectF &smallRect)
{
    return bigRect.contains(smallRect);
}

void Utils::setItemRect(QQuickItem *item, const QRectF &rect)
{
    item->setX(rect.x());
    item->setY(rect.y());
    item->setWidth(rect.width());
    item->setHeight(rect.height());
}

QRectF Utils::itemRect(QQuickItem *item)
{
    return QRectF(item->x(), item->y(), item->width(), item->height());
}

QJsonObject Utils::loadJsonFromFile(const QString &filePath)
{
    QFile loadFile(filePath);
    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning() << "Couldn't open save file: " + filePath;
        return QJsonObject();
    }

    QByteArray data = loadFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(data));

    loadFile.close();
    return loadDoc.object();
}

bool Utils::saveJsonToFile(const QJsonObject &data, const QString &filePath)
{
    QFile saveFile(filePath);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning() << "Couldn't open save file: " + filePath;
        return false;
    }

    QJsonDocument saveDoc(data);

    saveFile.write(saveDoc.toJson());
/*
#ifdef QT_DEBUG
    saveFile.write(saveDoc.toJson());
#else
    saveFile.write(saveDoc.toBinaryData());
#endif
*/

    saveFile.close();
    return true;
}

QQuickItem *Utils::createItem(QQuickItem *parent, QQmlComponent *component)
{
    QQuickItem* item = qobject_cast<QQuickItem*>(component->create(QQmlEngine::contextForObject(parent)));
    item->setParentItem(parent);
    return item;
}

QQuickItem *Utils::createItem(QQuickItem *parent, const QString &componentFile)
{
    QQmlEngine *engine = QQmlEngine::contextForObject(parent)->engine();
    QQmlComponent component(engine, QUrl(componentFile));
    return createItem(parent, &component);
}

QString Utils::url2Path(const QUrl &url)
{
    return url.toLocalFile();
}

QString Utils::url2Name(const QUrl &url)
{
    auto n = url.fileName();
    return n.left(n.length() - 4);
}

QUrl Utils::fileFolderUrl(const QUrl &url)
{
    QFileInfo info(url.path());
    return QUrl::fromLocalFile(info.dir().path());
}

QUrl Utils::changeUrlFileName(const QUrl &url, const QString &newName)
{
    QString oldName = Utils::url2Name(url);
    QString urlString = url.toString();
    urlString.replace(urlString.lastIndexOf(oldName), oldName.length(), newName);
    return QUrl(urlString);
}

QVariant Utils::settingValue(const QString &key, const QVariant &defaultValue)
{
    return Utils::m_settings.value(key, defaultValue);
}

QVariant Utils::settingValue(const QString &key)
{
    return Utils::settingValue(key, QVariant());
}

void Utils::setSettingValue(const QString &key, const QVariant &value)
{
    Utils::m_settings.setValue(key, value);
}

bool Utils::settingContains(const QString &key)
{
    return Utils::m_settings.contains(key);
}

bool Utils::renameFile(const QUrl &fileUrl, const QString &newName)
{
    QString newPath = Utils::changeUrlFileName(fileUrl, newName).toLocalFile();
    QFile file(fileUrl.toLocalFile());
    return file.rename(newPath);
}
